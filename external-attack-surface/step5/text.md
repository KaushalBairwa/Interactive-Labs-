# Task 5 — Identify the insecure service

Review the hidden directory and its migration note:

```bash
curl http://target.securewithme.local/backup-console/
curl http://target.securewithme.local/backup-console/readme.txt
```

Connect to the exposed legacy port and inspect its greeting:

```bash
nc target.securewithme.local 2121
```

Press `Ctrl+C` after reading the banner.

Save the protocol name—not the product version:

```bash
lab-submit service YOUR_ANSWER
```

Then click **CHECK**.

<details>
<summary>Hint</summary>

The banner begins with a three-digit `220` response, commonly used by a plaintext file-transfer protocol.

</details>
