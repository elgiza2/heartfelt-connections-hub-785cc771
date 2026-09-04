import re,subprocess,json
missing="""abliteration_keys agent_checkpoints agent_credentials agent_memory agent_plans agent_questions agent_tick_config alibaba_video_models app_updates browser_use_keys clerk_links cloud_browser_settings computer_events computer_memory computer_tasks dev_deploys dev_events dev_projects dev_runs dev_tasks freestyle_keys local_device_commands local_devices long_run_events long_runs mail_messages mailboxes mcp_call_log mcp_oauth_states mcp_tool_approvals provider_api_keys user_api_apps user_knowledge telegram_media""".split()
out={}
for t in missing:
    p=subprocess.run(['rg','-n','-A','12',f"from\\(['\\\"]{t}['\\\"]\\)",'src','supabase/functions','api'],capture_output=True,text=True).stdout
    cols=set(re.findall(r"\.eq\('(\w+)'",p))|set(re.findall(r"\.order\('(\w+)'",p))|set(re.findall(r"^\s*(\w+):",p,re.M))|set(re.findall(r"select\('([^']+)'",p))
    exp=set()
    for c in cols:
        for x in re.split(r'[,\s]+',c):
            x=x.strip()
            if re.fullmatch(r'[a-z][a-z0-9_]*',x or ''): exp.add(x)
    out[t]=sorted(exp-{'from','select','insert','update','order','eq','data','error','const','await','if','return','true','false','null','count','head','string','number','boolean','any'})
print(json.dumps(out,indent=1))
