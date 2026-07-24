# Task 1 — Confirm the authorised target

A professional assessment begins by confirming the written scope. Scanning the wrong system can create legal and operational risk.

Read the engagement file:

```bash
cat /root/engagement/scope.txt
```

Confirm that the hostname resolves inside the lab:

```bash
getent hosts target.securewithme.local
```

Save the approved hostname:

```bash
lab-submit hostname YOUR_ANSWER
```

Then click **CHECK**.

<details>
<summary>Hint</summary>

Use the value shown after `Approved target`.

</details>
