import json


class Incident:

    def __init__(
        self,
        incident_id,
        service,
        severity,
        finding_type,
        account,
        region,
        event_time,
    ):
        self.incident_id = incident_id
        self.service = service
        self.severity = severity
        self.finding_type = finding_type
        self.account = account
        self.region = region
        self.event_time = event_time
        self.decision = ""

    def to_dict(self):
        return {
            "incident_id": self.incident_id,
            "service": self.service,
            "severity": self.severity,
            "finding_type": self.finding_type,
            "account": self.account,
            "region": self.region,
            "event_time": self.event_time,
            "decision": self.decision,
        }

    def to_json(self):
        return json.dumps(self.to_dict(), indent=4)