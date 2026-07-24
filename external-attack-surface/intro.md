# External Attack-Surface Discovery

You are a junior security analyst performing an **authorised external reconnaissance assessment**.

A small organisation has provided one in-scope target inside this disposable lab. Your objective is to:

1. confirm the approved hostname;
2. discover exposed TCP ports;
3. fingerprint the web server;
4. inspect web-discovery clues;
5. identify a plaintext legacy service; and
6. retrieve the assessment flag.

## Rules of engagement

- Test only the target defined in `/root/engagement/scope.txt`.
- Do not scan public IP addresses or external domains.
- All services are simulated and exist only inside this temporary environment.
- Record each answer with the `lab-submit` helper before clicking **CHECK**.

Example:

```bash
lab-submit hostname example.internal
```

The terminal will become available after the controlled target finishes starting.
