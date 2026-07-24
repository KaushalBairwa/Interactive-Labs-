# Task 6 — Retrieve the assessment flag

The migration note exposed credentials for the plaintext legacy service. Use them only against the controlled target.

Run:

```bash
printf 'USER analyst\r\nPASS BLUE-ORBIT-72\r\nRETR flag.txt\r\nQUIT\r\n' | nc target.securewithme.local 2121
```

Locate the value in this format:

```text
SWM{...}
```

Save it:

```bash
lab-submit flag 'SWM{YOUR_FLAG}'
```

Then click **CHECK**.

<details>
<summary>Why this matters</summary>

Plaintext transfer protocols expose credentials and data to interception. Production systems should use encrypted alternatives such as SFTP or properly configured FTPS, restrict network exposure and remove temporary credentials.

</details>
