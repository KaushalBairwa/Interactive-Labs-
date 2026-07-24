# Lab complete — Attack surface mapped

You completed six verified reconnaissance tasks:

- confirmed the written scope;
- resolved the approved target;
- discovered three exposed TCP ports;
- fingerprinted the HTTP server;
- used `robots.txt` to locate hidden content;
- identified a plaintext FTP-style service; and
- retrieved the final flag.

## Key findings

| Finding | Risk | Recommended action |
|---|---|---|
| Detailed server version exposed | Helps attackers match public vulnerabilities | Reduce unnecessary banner detail and patch promptly |
| Sensitive path disclosed in `robots.txt` | Hidden paths are not access control | Protect sensitive routes with authentication and authorization |
| Migration credentials stored in web content | Enables unauthorised access | Remove credentials, rotate secrets and use a secret manager |
| Plaintext legacy transfer service | Credentials and files can be intercepted | Replace with SFTP or properly configured FTPS |
| Unnecessary externally exposed services | Increases attack surface | Restrict exposure with firewall and network policy |

Only use reconnaissance techniques against systems you own or have explicit permission to test.
