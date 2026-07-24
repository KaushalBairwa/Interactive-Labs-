# Task 4 — Locate hidden web content

Files intended for search-engine crawlers sometimes reveal paths that should not have been publicly exposed.

Inspect the standard discovery file:

```bash
curl http://target.securewithme.local/robots.txt
```

Open any disallowed path you find:

```bash
curl http://target.securewithme.local/PATH/
```

Save the hidden path, including its leading slash:

```bash
lab-submit hidden-path /YOUR-PATH/
```

Then click **CHECK**.

<details>
<summary>Hint</summary>

Look at the `Disallow` directive in `robots.txt`.

</details>
