# Task 2 — Find the overprivileged group

Inspect group membership:

```bash
jq '.[] | {name, members, risk}' /root/ad-case/data/groups.json
```

Then review relationships originating from the starting user:

```bash
grep -F 'NORTHSTAR\helpdesk.a' /root/ad-case/data/relationships.csv
```

Submit the group containing the starting user:

```bash
lab-submit group 'GROUP NAME'
```

Then click **CHECK**.
