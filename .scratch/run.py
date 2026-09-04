import sys,json,urllib.request,re
env=dict(re.findall(r'^(\w+)="?([^"\n]+)"?$', open('/dev-server/.env').read(), re.M))
url=env['VITE_SUPABASE_URL']; key=env['VITE_SUPABASE_PUBLISHABLE_KEY']
def run(sql):
    req=urllib.request.Request(url+'/rest/v1/rpc/__tmp_migrate', data=json.dumps({'p_sql':sql}).encode(), headers={'apikey':key,'Authorization':'Bearer '+key,'Content-Type':'application/json'})
    try: return 'OK '+urllib.request.urlopen(req).read().decode()[:80]
    except urllib.error.HTTPError as e: return 'ERR '+str(e.code)+' '+e.read().decode()[:800]
if __name__=='__main__':
    for f in sys.argv[1:]:
        stmts=[s for s in open(f).read().split(';\n') if s.strip()]
        ok=err=0; msgs=[]
        for s in stmts:
            r=run(s+';')
            if r.startswith('OK'): ok+=1
            else:
                err+=1
                if len(msgs)<8: msgs.append(s.split('\n')[0][:90]+' -> '+r[:200])
        print(f, 'ok',ok,'err',err)
        for m in msgs: print('  ',m)
