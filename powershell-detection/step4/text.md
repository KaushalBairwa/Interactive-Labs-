# Task 4 — Identify the affected user

Run:

```bash
jq 'select(.EventID == 4688) | {SubjectDomainName, SubjectUserName, NewProcessName}' /root/investigation/logs/windows-security.jsonl
```

Submit the account in `DOMAIN\user` format:

```bash
lab-submit user 'DOMAIN\user'
```

Then click **CHECK**.
