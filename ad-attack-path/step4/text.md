# Task 4 — Identify the service account

Use the dangerous relationship to determine which service account can be
controlled:

```bash
grep -i 'GenericAll' /root/ad-case/data/relationships.csv
```

Submit the complete account name:

```bash
lab-submit service-account 'DOMAIN\account'
```

Then click **CHECK**.
