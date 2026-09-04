/** @doc telegram-tasks-bot — Telegram webhook: lets a user manage tasks via chat commands, linked by telegram chat id. */
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false } },
);

const BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN");

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

async function sendMessage(chatId: number | string, text: string) {
  if (!BOT_TOKEN) {
    console.error("telegram-tasks-bot: TELEGRAM_BOT_TOKEN not set");
    return;
  }
  try {
    await fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ chat_id: chatId, text, parse_mode: "Markdown" }),
    });
  } catch (error) {
    console.error("telegram sendMessage failed", error);
  }
}

async function findUserId(chatId: number): Promise<string | null> {
  const { data } = await admin
    .from("profiles")
    .select("id")
    .eq("telegram_chat_id", chatId)
    .maybeSingle();
  return (data as { id: string } | null)?.id ?? null;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ ok: true });

  if (!BOT_TOKEN) return json({ error: "TELEGRAM_BOT_TOKEN not configured" }, 503);

  let update: Record<string, unknown> = {};
  try {
    update = await req.json();
  } catch {
    return json({ ok: true });
  }

  const message = (update.message ?? update.edited_message) as Record<string, unknown> | undefined;
  if (!message) return json({ ok: true });

  const chat = message.chat as Record<string, unknown>;
  const chatId = Number(chat.id);
  const text = String(message.text ?? "").trim();

  try {
    if (text === "/start") {
      await sendMessage(
        chatId,
        `👋 Welcome to Megsy Tasks Bot!\n\nLink your account first with */link <code>* using the code from your Megsy settings page.\n\nOnce linked, you can:\n• */tasks* — list your open tasks\n• */add <title>* — add a new task\n• */done <task id>* — mark a task complete`,
      );
      return json({ ok: true });
    }

    if (text.startsWith("/link")) {
      const code = text.replace("/link", "").trim();
      if (!code) {
        await sendMessage(chatId, "Usage: /link <code> (find your code in Megsy settings)");
        return json({ ok: true });
      }
      const { data: profile, error } = await admin
        .from("profiles")
        .select("id")
        .eq("telegram_link_code", code)
        .maybeSingle();
      if (error || !profile) {
        await sendMessage(chatId, "❌ Invalid or expired link code.");
        return json({ ok: true });
      }
      await admin
        .from("profiles")
        .update({ telegram_chat_id: chatId, telegram_link_code: null })
        .eq("id", (profile as { id: string }).id);
      await sendMessage(chatId, "✅ Linked! Try /tasks to see your open tasks.");
      return json({ ok: true });
    }

    const userId = await findUserId(chatId);
    if (!userId) {
      await sendMessage(chatId, "You're not linked yet. Send /start to get started.");
      return json({ ok: true });
    }

    if (text === "/tasks") {
      const { data: tasks } = await admin
        .from("tasks")
        .select("id,title,status")
        .eq("user_id", userId)
        .neq("status", "done")
        .order("created_at", { ascending: false })
        .limit(20);
      if (!tasks || tasks.length === 0) {
        await sendMessage(chatId, "🎉 No open tasks.");
      } else {
        const lines = tasks
          .map((t: Record<string, unknown>) => `• \`${t.id}\` ${t.title}`)
          .join("\n");
        await sendMessage(chatId, `📋 *Open tasks:*\n${lines}`);
      }
      return json({ ok: true });
    }

    if (text.startsWith("/add")) {
      const title = text.replace("/add", "").trim();
      if (!title) {
        await sendMessage(chatId, "Usage: /add <task title>");
        return json({ ok: true });
      }
      const { error } = await admin.from("tasks").insert({
        user_id: userId,
        title,
        status: "todo",
      });
      if (error) {
        await sendMessage(chatId, `❌ Could not add task: ${error.message}`);
      } else {
        await sendMessage(chatId, `✅ Added: ${title}`);
      }
      return json({ ok: true });
    }

    if (text.startsWith("/done")) {
      const taskId = text.replace("/done", "").trim();
      if (!taskId) {
        await sendMessage(chatId, "Usage: /done <task id>");
        return json({ ok: true });
      }
      const { error } = await admin
        .from("tasks")
        .update({ status: "done" })
        .eq("id", taskId)
        .eq("user_id", userId);
      if (error) {
        await sendMessage(chatId, `❌ Could not update task: ${error.message}`);
      } else {
        await sendMessage(chatId, "✅ Marked done.");
      }
      return json({ ok: true });
    }

    await sendMessage(chatId, "Unknown command. Try /tasks, /add <title>, /done <id>.");
    return json({ ok: true });
  } catch (error) {
    console.error("telegram-tasks-bot error", error);
    return json({ ok: true });
  }
});
