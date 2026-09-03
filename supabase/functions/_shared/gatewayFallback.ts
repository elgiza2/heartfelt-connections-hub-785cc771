/**
 * Zero-configuration model fallback.
 *
 * The chat functions prefer the workspace's own Model Studio credentials, but
 * those need a key the owner has to provide. When no usable key exists (or every
 * key fails), we fall back to the Lovable AI Gateway, whose `LOVABLE_API_KEY` is
 * provisioned automatically for this project — so chat keeps working with no
 * manual setup at all.
 *
 * The gateway speaks the OpenAI-compatible chat-completions protocol, exactly
 * like Model Studio, so the same streaming SSE body flows back to the client.
 */

const GATEWAY_URL = "https://ai.gateway.lovable.dev/v1/chat/completions";

/** Default gateway chat model (fast, multilingual, streams reasoning). */
export const GATEWAY_MODEL = "google/gemini-3.7-flash";

export function gatewayKey(): string | null {
  return Deno.env.get("LOVABLE_API_KEY")?.trim() || null;
}

export const hasGateway = () => Boolean(gatewayKey());

/**
 * Translates a Model Studio payload into a gateway payload: DashScope-only
 * fields are dropped and the model id is replaced with a gateway model.
 */
export function toGatewayPayload(payload: Record<string, unknown>): Record<string, unknown> {
  const drop = new Set([
    "model",
    "enable_thinking",
    "thinking_budget",
    "enable_search",
    "search_options",
    "stream_options",
    "translation_options",
    "result_format",
  ]);
  const out: Record<string, unknown> = {};
  for (const [name, value] of Object.entries(payload)) {
    if (drop.has(name) || value === undefined) continue;
    out[name] = value;
  }
  out.model = GATEWAY_MODEL;
  if (payload.stream) out.stream_options = { include_usage: true };
  return out;
}

/** Calls the gateway. Returns null when it is unavailable or errors out. */
export async function callGateway(
  payload: Record<string, unknown>,
): Promise<Response | null> {
  const key = gatewayKey();
  if (!key) return null;
  try {
    const response = await fetch(GATEWAY_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Lovable-API-Key": key,
        "X-Lovable-AIG-SDK": "fetch",
      },
      body: JSON.stringify(toGatewayPayload(payload)),
    });
    if (response.ok) return response;
    const detail = (await response.text().catch(() => "")).slice(0, 400);
    console.error(`ai-gateway fallback [${response.status}]: ${detail}`);
    return null;
  } catch (error) {
    console.error("ai-gateway fallback request failed", error);
    return null;
  }
}
