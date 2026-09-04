import re, collections
tables=collections.OrderedDict()
for line in open('supabase/schema/01_tables_columns.sql'):
    m=re.match(r'^-- public\.(\w+) \| (\w+) \| (.+?) \| (not null|null) \| default=(.*)$', line.strip())
    if not m: continue
    t,c,typ,nn,dflt=m.groups(); tables.setdefault(t,[]).append((c,typ,nn,dflt))
skip=re.compile(r'^(gram_|game_|pvp_|music_|prize_|mining_|attacks|battle_|servers|user_servers|stakes|staking_|ad_watch|auto_notification|bot_admin|telegram_)')
def coltype(t,c,typ,dflt):
    if typ=='USER-DEFINED':
        if c=='embedding': return 'vector(1536)'
        m=re.search(r"::(\w+)$", dflt or '')
        if m: return m.group(1)
        if t=='user_roles' and c=='role': return 'app_role'
        return 'text'
    if typ=='ARRAY':
        m=re.search(r"::(\w+\[\])", dflt or '')
        return m.group(1) if m else 'text[]'
    return typ
out=[]; kept=[]
for t,cols in tables.items():
    if skip.match(t): continue
    kept.append(t); lines=[]; names=[c for c,_,_,_ in cols]
    for c,typ,nn,dflt in cols:
        s=f'  "{c}" {coltype(t,c,typ,dflt)}'
        if dflt and dflt!='-': s+=f' default {dflt}'
        if nn=='not null': s+=' not null'
        lines.append(s)
    if 'id' in names: lines.append('  primary key ("id")')
    out.append(f'create table if not exists public.{t} (\n'+',\n'.join(lines)+'\n);')
    out.append(f'alter table public.{t} enable row level security;')
    out.append(f'grant select, insert, update, delete on public.{t} to authenticated;\ngrant all on public.{t} to service_role;\ngrant select on public.{t} to anon;')
open('.scratch/tables.sql','w').write('\n'.join(out)+'\n')
# policies
txt=open('supabase/schema/03_rls_policies.sql').read().splitlines()
keep=set(kept); pol=[]; i=0
while i<len(txt):
    m=re.match(r'^-- public\.(\w+) \((.+), cmd=(\w+), roles=\{(.*)\}\)$', txt[i].strip())
    if m:
        t,name,cmd,roles=m.groups()
        using=txt[i+1].strip()[10:] if i+1<len(txt) else '-'
        chk=txt[i+2].strip()[15:] if i+2<len(txt) else '-'
        i+=3
        if t not in keep: continue
        s=f'create policy "{name}" on public.{t} for {cmd.lower()} to {roles.replace("public","authenticated, anon")}'
        if using!='-': s+=f' using ({using})'
        if chk!='-': s+=f' with check ({chk})'
        pol.append(s+';'); continue
    i+=1
open('.scratch/policies.sql','w').write('\n'.join(pol)+'\n')
print(len(kept),'tables',len(pol),'policies')
