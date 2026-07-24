# Task 5 — Find the destination IP

Run:

```bash
jq 'select(.EventID == 3)' /root/investigation/logs/sysmon.jsonl
```

Submit the destination IP:

```bash
lab-submit ip YOUR_ANSWER
```

Then click **CHECK**.
