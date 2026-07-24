#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
LAB_ROOT="/opt/interactive-lab"
CASE_ROOT="/root/ad-case"

mkdir -p "$LAB_ROOT" "$CASE_ROOT/data" /root/answers
rm -f "$LAB_ROOT/.ready"

apt-get update -qq
apt-get install -y -qq jq python3 coreutils grep sed gawk >/var/log/interactive-lab-packages.log 2>&1

cat > /usr/local/bin/lab-submit <<'EOF'
#!/bin/bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: lab-submit <starting-user|group|relationship|service-account|path|remediation|flag> <answer>"
  exit 1
fi

key="$1"
shift

case "$key" in
  starting-user|group|relationship|service-account|path|remediation|flag) ;;
  *)
    echo "Unknown task key: $key"
    exit 1
    ;;
esac

mkdir -p /root/answers
printf '%s\n' "$*" > "/root/answers/$key"
echo "Answer saved for: $key"
EOF
chmod +x /usr/local/bin/lab-submit

cat > "$CASE_ROOT/case-summary.txt" <<'EOF'
CASE ID: ID-2026-021
DOMAIN: NORTHSTAR.LOCAL
OBJECTIVE: Review a suspected privilege-escalation route to the domain controller.

Starting context:
- A helpdesk user was identified during an access review.
- The account is not a Domain Admin.
- The investigation must determine whether delegated rights create a path to DC01.
EOF

cat > "$CASE_ROOT/data/users.json" <<'EOF'
[
  {
    "name": "NORTHSTAR\\helpdesk.a",
    "displayName": "Aarav Helpdesk",
    "enabled": true,
    "department": "IT Support",
    "risk": "review-required"
  },
  {
    "name": "NORTHSTAR\\svc_backup",
    "displayName": "Backup Service",
    "enabled": true,
    "department": "Infrastructure",
    "serviceAccount": true,
    "tier": "Tier-0-adjacent"
  },
  {
    "name": "NORTHSTAR\\analyst.r",
    "displayName": "Riya Analyst",
    "enabled": true,
    "department": "Security Operations",
    "risk": "normal"
  }
]
EOF

cat > "$CASE_ROOT/data/groups.json" <<'EOF'
[
  {
    "name": "Helpdesk Operators",
    "description": "Delegated support group",
    "members": [
      "NORTHSTAR\\helpdesk.a"
    ],
    "risk": "high"
  },
  {
    "name": "Server Backup Admins",
    "description": "Backup operators for critical servers",
    "members": [
      "NORTHSTAR\\svc_backup"
    ],
    "risk": "critical"
  },
  {
    "name": "Domain Admins",
    "description": "Tier-0 administrative group",
    "members": [],
    "risk": "critical"
  }
]
EOF

cat > "$CASE_ROOT/data/computers.json" <<'EOF'
[
  {
    "name": "DC01.NORTHSTAR.LOCAL",
    "role": "Domain Controller",
    "operatingSystem": "Windows Server 2022",
    "tier": "Tier-0"
  },
  {
    "name": "FS01.NORTHSTAR.LOCAL",
    "role": "File Server",
    "operatingSystem": "Windows Server 2022",
    "tier": "Tier-1"
  },
  {
    "name": "HD-WS-14.NORTHSTAR.LOCAL",
    "role": "Helpdesk Workstation",
    "operatingSystem": "Windows 11",
    "tier": "Tier-2"
  }
]
EOF

cat > "$CASE_ROOT/data/relationships.csv" <<'EOF'
source,relationship,target,source_type,target_type,risk
NORTHSTAR\helpdesk.a,MemberOf,Helpdesk Operators,User,Group,medium
Helpdesk Operators,GenericAll,NORTHSTAR\svc_backup,Group,User,critical
NORTHSTAR\svc_backup,MemberOf,Server Backup Admins,User,Group,high
Server Backup Admins,AdminTo,DC01.NORTHSTAR.LOCAL,Group,Computer,critical
DC01.NORTHSTAR.LOCAL,Contains,Domain Admins,Computer,Group,critical
EOF

cat > "$CASE_ROOT/data/attack-path.json" <<'EOF'
{
  "case_id": "ID-2026-021",
  "start": "NORTHSTAR\\helpdesk.a",
  "goal": "DC01.NORTHSTAR.LOCAL",
  "path_length": 4,
  "path": [
    {
      "source": "NORTHSTAR\\helpdesk.a",
      "relationship": "MemberOf",
      "target": "Helpdesk Operators"
    },
    {
      "source": "Helpdesk Operators",
      "relationship": "GenericAll",
      "target": "NORTHSTAR\\svc_backup"
    },
    {
      "source": "NORTHSTAR\\svc_backup",
      "relationship": "MemberOf",
      "target": "Server Backup Admins"
    },
    {
      "source": "Server Backup Admins",
      "relationship": "AdminTo",
      "target": "DC01.NORTHSTAR.LOCAL"
    }
  ],
  "critical_control_failure": "GenericAll delegated from Helpdesk Operators to NORTHSTAR\\svc_backup",
  "recommended_primary_fix": "Remove GenericAll"
}
EOF

cat > "$CASE_ROOT/remediation.md" <<'EOF'
# Remediation guidance

Primary corrective action:

1. Remove the `GenericAll` permission from `Helpdesk Operators` over
   `NORTHSTAR\svc_backup`.

Additional actions:

2. Rotate the service-account credential.
3. Convert the account to a managed service account where feasible.
4. Review membership of `Server Backup Admins`.
5. Restrict administrative logon paths to Tier-0 systems.
6. Continuously review delegated Active Directory ACLs.
EOF

cat > "$CASE_ROOT/incident.json" <<'EOF'
{
  "case_id": "ID-2026-021",
  "severity": "critical",
  "validated_path": true,
  "flag": "SWM{genericall_to_domain_controller}"
}
EOF

cat > /usr/local/bin/ad-path <<'EOF'
#!/usr/bin/env python3
import csv
from collections import defaultdict, deque

csv_path = "/root/ad-case/data/relationships.csv"
start = r"NORTHSTAR\helpdesk.a"
goal = "DC01.NORTHSTAR.LOCAL"

graph = defaultdict(list)

with open(csv_path, newline="", encoding="utf-8") as handle:
    for row in csv.DictReader(handle):
        graph[row["source"]].append(
            (row["target"], row["relationship"])
        )

queue = deque([(start, [])])
visited = {start}
found = None

while queue:
    node, path = queue.popleft()
    if node == goal:
        found = path
        break

    for target, relation in graph[node]:
        if target in visited:
            continue
        visited.add(target)
        queue.append(
            (
                target,
                path + [
                    {
                        "source": node,
                        "relationship": relation,
                        "target": target,
                    }
                ],
            )
        )

if not found:
    print("No path found")
    raise SystemExit(1)

print(f"Shortest path from {start} to {goal}")
print("-" * 72)

for index, edge in enumerate(found, start=1):
    print(
        f"{index}. {edge['source']} "
        f"--[{edge['relationship']}]--> "
        f"{edge['target']}"
    )

print("-" * 72)
print(f"Path length: {len(found)}")
EOF
chmod +x /usr/local/bin/ad-path

touch "$LAB_ROOT/.ready"
