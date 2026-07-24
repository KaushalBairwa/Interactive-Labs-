# Task 2 — Discover the exposed TCP ports

Use a TCP SYN scan against the approved hostname:

```bash
nmap -Pn -sS target.securewithme.local
```

For a complete port sweep:

```bash
nmap -Pn --open -p- target.securewithme.local
```

Save the discovered open ports as comma-separated numbers:

```bash
lab-submit ports PORT1,PORT2,PORT3
```

Then click **CHECK**.

<details>
<summary>Hint</summary>

There are three intentionally exposed TCP services. Do not include closed ports.

</details>
