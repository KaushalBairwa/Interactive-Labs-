# Task 6 — Map the MITRE technique

Run:

```bash
jq '.rule.mitre' /root/investigation/logs/wazuh-alerts.jsonl
grep -i "attack.t" /root/investigation/rules/powershell-encoded.yml
```

Submit the PowerShell sub-technique:

```bash
lab-submit mitre YOUR_ANSWER
```

Then click **CHECK**.
