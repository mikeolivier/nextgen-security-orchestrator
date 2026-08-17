from orchestrator.incident import Incident


def test_incident_creation():

    incident = Incident(
        incident_id="INC-001",
        service="GuardDuty",
        severity="HIGH",
        finding_type="CryptoCurrency:EC2/BitcoinTool.B",
        account="123456789012",
        region="ca-central-1",
        event_time="2026-08-16T18:00:00Z",
    )

    assert incident.service == "GuardDuty"
    assert incident.severity == "HIGH"
    assert incident.decision == ""