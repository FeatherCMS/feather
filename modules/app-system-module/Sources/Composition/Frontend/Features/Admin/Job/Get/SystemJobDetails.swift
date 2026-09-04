import FeatherAdmin
import HTML
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemJobDetails: Leaf {
    let job: Components.Schemas.SystemJobSchema
    let breadcrumb: AdminBreadcrumb.State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).html()
            H1("Worker job details")
            let payload = SystemJobPayload(job: job)
            AdminDetailsField(label: "Job", value: payload.name).html()
            AdminDetailsField(label: "ID", value: job.id).html()
            AdminDetailsField(label: "Queue", value: job.queueName).html()
            AdminDetailsField(label: "Status", value: statusLabel(job.status)).html()
            AdminDetailsField(label: "Worker", value: job.workerId ?? "—").html()
            AdminDetailsField(
                label: "Last modified",
                value: String(describing: job.lastModified)
            ).html()
            if let queuedAt = payload.queuedAt {
                AdminDetailsField(label: "Queued at", value: queuedAt).html()
            }
            if let attempt = payload.attempt {
                AdminDetailsField(label: "Attempt", value: attempt).html()
            }
            if let nextScheduledAt = payload.nextScheduledAt {
                AdminDetailsField(
                    label: "Next scheduled at",
                    value: nextScheduledAt
                ).html()
            }
            if let traceContext = payload.traceContext {
                AdminDetailsField(label: "Trace context", value: traceContext).html()
            }
            if let sender = payload.sender {
                AdminDetailsField(label: "From", value: sender).html()
            }
            if let recipient = payload.recipient {
                AdminDetailsField(label: "To", value: recipient).html()
            }
            if let subject = payload.subject {
                AdminDetailsField(label: "Subject", value: subject).html()
            }
            if let message = payload.message {
                AdminDetailsField(label: "Message", value: message).html()
            }
            AdminDetailsField(label: "Payload", value: job.payload).html()
            Div {
                AdminNavigationButton(
                    "Back to worker jobs",
                    href: "/admin/system/jobs/"
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }

    private func statusLabel(_ status: Int) -> String {
        switch status {
        case 0: "Pending"
        case 1: "Processing"
        case 2: "Failed"
        case 3: "Cancelled"
        case 5: "Completed"
        default: "Unknown (\(status))"
        }
    }
}
