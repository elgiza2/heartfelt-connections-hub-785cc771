import sys
sys.path.insert(0,'.scratch')
from run import run
sql=open('.scratch/functions.sql').read().split('\n;;;\n')
ok=err=0; msgs=[]
for s in sql:
    r=run(s)
    if r.startswith('OK'): ok+=1
    else:
        err+=1
        if len(msgs)<15: msgs.append(s.split('\n')[0][:80]+' -> '+r[:160])
print('functions ok',ok,'err',err)
for m in msgs: print(' ',m)
