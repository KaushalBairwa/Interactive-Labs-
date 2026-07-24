# Investigation complete

You reconstructed this execution chain:

```text
Quarterly_Review.docm
        ↓
WINWORD.EXE
        ↓
powershell.exe -EncodedCommand
        ↓
198.51.100.42:80
```

## Findings

- Suspicious process: `powershell.exe`
- Parent process: `WINWORD.EXE`
- User: `NORTHSTAR\jsingh`
- Destination: `198.51.100.42`
- MITRE ATT&CK: `T1059.001 — PowerShell`
- Sigma-style matches: `1`

No malware was executed. All evidence came from a controlled training dataset.
