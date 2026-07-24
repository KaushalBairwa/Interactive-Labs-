# Active Directory Attack-Path Investigation

You are investigating a controlled enterprise identity graph after an access
review identified potentially excessive permissions.

This lab uses a **prepared BloodHound-style dataset**. It does not deploy a live
Windows domain and does not execute credential attacks.

You will analyse:

- users;
- groups;
- computers;
- identity relationships;
- a calculated shortest path; and
- remediation guidance.

## Objective

Determine how a low-privileged helpdesk account could reach the domain
controller through inherited group membership and dangerous delegated access.

Submit answers with:

```bash
lab-submit <task> <answer>
```

Start by listing the case files:

```bash
find /root/ad-case -maxdepth 2 -type f -print
```
