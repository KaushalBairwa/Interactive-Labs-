# Task 1 — Identify the suspicious process

Run:

```bash
jq 'select(.EventID == 1)' /root/investigation/logs/sysmon.jsonl
```

Submit the suspicious executable name:

```bash
lab-submit process YOUR_ANSWER
```

Then click **CHECK**.
