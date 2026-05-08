import json

try:
    with open('C:\\Users\\DELL\\Desktop\\conexion\\github_events.json', 'r', encoding='utf-16') as f:
        events = json.load(f)
    for ev in events:
        if ev['type'] == 'PushEvent':
            ref = ev['payload'].get('ref', '')
            commits = ev['payload'].get('commits', [])
            head = ev['payload'].get('head', '')
            print(f"Push to {ref}: {len(commits)} commits. Head SHA: {head}")
            for c in commits:
                print(f"  [{c.get('sha', '')[:7]}] {c.get('message', '')}")
            print("-" * 40)
except Exception as e:
    print("Error:", e)
