# Task 1 — Identify the starting user

Read the case summary:

```bash
cat /root/ad-case/case-summary.txt
```

Inspect the users:

```bash
jq . /root/ad-case/data/users.json
```

Submit the low-privileged account that begins the suspected attack path:

```bash
lab-submit starting-user 'DOMAIN\user'
```

Then click **CHECK**.
