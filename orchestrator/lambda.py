

# from incident import Incident
# from notification_engine import notify


# def lambda_handler(event, context):

    # print("Security Orchestrator Started")

    # Existing logic will be migrated here

    from logger import log_event

log_event(
    "INFO",
    "Incident Received",
    severity="HIGH",
    service="GuardDuty"
)