


# NextGen Security Operations Playbook

## Incident Lifecycle

### 1. Detection
- GuardDuty detects suspicious activity.
- EventBridge receives the finding.

### 2. Routing
- EventBridge forwards the event to the Security Orchestrator.

### 3. Decision
- Lambda extracts:
  - Severity
  - Finding Type
  - Account
  - Region
  - Event Time

### 4. Notification
- HIGH findings notify the SOC through SNS.

### 5. Incident Record
- Lambda creates a structured incident object.
- CloudWatch stores execution logs.

### 6. Containment
- Manual today.
- Future versions:
  - Disable IAM Access Keys
  - Isolate EC2
  - Block Public S3
  - Quarantine Resources

### 7. Investigation
SOC Analyst reviews:
- GuardDuty
- Security Hub
- CloudTrail
- CloudWatch Logs

### 8. Recovery
Restore services after investigation.

### 9. Lessons Learned
Update detection rules.
Improve automation.
Improve playbooks.