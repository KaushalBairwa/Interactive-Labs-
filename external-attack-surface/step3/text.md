# Task 3 — Fingerprint the web service

Service banners can reveal products and versions that need patching or additional investigation.

Run targeted service detection:

```bash
nmap -Pn -sV -p 80,2121,8080 target.securewithme.local
```

Inspect the HTTP headers directly:

```bash
curl -I http://target.securewithme.local
```

Save the complete product/version shown in the `Server` header:

```bash
lab-submit web-version YOUR_ANSWER
```

Then click **CHECK**.

<details>
<summary>Hint</summary>

The expected format resembles `Product/1.2.3`.

</details>
