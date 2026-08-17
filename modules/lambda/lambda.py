import json
import os
import boto3

sns = boto3.client("sns")

#helper function:

def create_incident(context, source, severity, finding_type, account, region, event_time):

    return {
        "incident_id": context.aws_request_id,
        "service": source,
        "severity": severity,
        "finding_type": finding_type,
        "account": account,
        "region": region,
        "event_time": event_time,
        "decision": ""
    }

def notify_soc(subject, message):

    notify_soc(
    "...",
    "..."
)

def lambda_handler(event, context):

    detail = event.get("detail", {})

    severity = detail.get("severity", "UNKNOWN")
    finding_type = detail.get("type", "UNKNOWN")
    account = event.get("account", "UNKNOWN")
    region = event.get("region", "UNKNOWN")
    event_time = event.get("time", "UNKNOWN")
    source = event.get("source", "UNKNOWN")

    print("=" * 60)
    print("SECURITY INCIDENT RECEIVED")
    print("=" * 60)

    print(f"Detection Service : {source}")
    print(f"Severity          : {severity}")
    print(f"Finding Type      : {finding_type}")
    print(f"Account           : {account}")
    print(f"Region            : {region}")
    print(f"Time              : {event_time}")

    print("\nDecision Engine")

    incident = create_incident(
    context,
    source,
    severity,
    finding_type,
    account,
    region,
    event_time
)

    if severity == "HIGH":
        incident["decision"] = "Notify SOC Immediately"
        print("Action : Notify SOC Immediately")

        notify_soc(
    "...",
    "..."
)
Security Incident Detected

Severity : {severity}
Finding  : {finding_type}
Account  : {account}
Region   : {region}
Time     : {event_time}

Recommended Action:
Investigate immediately.
"""
        )

    elif severity == "CRITICAL":
        incident["decision"] = "Automatic Containment"
        print("=" * 60)
        print("AUTO-REMEDIATION INITIATED")
        print("=" * 60)

        print("Containment Status : STARTED")
        print("Action             : Notify SOC")
        print("Action             : Awaiting next remediation step")

        sns.publish(
            TopicArn=os.environ["SECURITY_TOPIC_ARN"],
            Subject="🚨 CRITICAL Security Incident",
            Message="""
Automatic containment workflow has started.

Current Status:
- SOC Notified
- Incident Logged
- Ready for Automated Containment
"""
        )

    elif severity == "MEDIUM":
        incident["decision"] = "Create Investigation Ticket"
        print("Action : Create Investigation Ticket")

    else:
        incident["decision"] = "Log Only"
        print("Action : Log Only")

    print("=" * 60)
    print("\n========== INCIDENT RECORD ==========")
    print(json.dumps(incident, indent=4))
    print("=====================================\n")


    return {
        "statusCode": 200,
        "body": "Security event processed successfully."
    }
