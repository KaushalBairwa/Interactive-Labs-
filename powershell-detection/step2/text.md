# Task 2 — Find the parent process

Run:

```bash
jq 'select(.EventID == 1) | {Image, ParentImage, CommandLine}' /root/investigation/logs/sysmon.jsonl
```

Submit the parent executable that launched PowerShell:

```bash
lab-submit parent YOUR_ANSWER
```

Then click **CHECK**.
