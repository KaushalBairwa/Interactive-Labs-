# Investigation complete

You identified and validated this attack path:

```text
NORTHSTAR\helpdesk.a
        ↓ MemberOf
Helpdesk Operators
        ↓ GenericAll
NORTHSTAR\svc_backup
        ↓ MemberOf
Server Backup Admins
        ↓ AdminTo
DC01.NORTHSTAR.LOCAL
```

## Root cause

The critical control failure was the `GenericAll` permission delegated from
`Helpdesk Operators` to `NORTHSTAR\svc_backup`.

## Primary remediation

Remove that permission, rotate the service-account credential and review all
Tier-0-adjacent delegated rights.

This lab used a prepared identity graph only. It did not deploy or attack a live
Active Directory domain.
