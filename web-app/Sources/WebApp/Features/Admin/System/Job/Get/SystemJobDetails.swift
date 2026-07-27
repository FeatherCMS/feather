import AdminOpenAPI
import HTML
import SGML
import WebStandards

struct SystemJobDetails: Component {
    let job: Components.Schemas.SystemJobSchema
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1("Worker job details")
            let payload = SystemJobPayload(job: job)
            AdminDetailsField(label: "Job", value: payload.name)
            AdminDetailsField(label: "ID", value: job.id)
            AdminDetailsField(label: "Queue", value: job.queueName)
            AdminDetailsField(label: "Status", value: statusLabel(job.status))
            AdminDetailsField(label: "Worker", value: job.workerId ?? "—")
            AdminDetailsField(
                label: "Last modified",
                value: String(describing: job.lastModified)
            )
            if let queuedAt = payload.queuedAt {
                AdminDetailsField(label: "Queued at", value: queuedAt)
            }
            if let attempt = payload.attempt {
                AdminDetailsField(label: "Attempt", value: attempt)
            }
            if let nextScheduledAt = payload.nextScheduledAt {
                AdminDetailsField(
                    label: "Next scheduled at",
                    value: nextScheduledAt
                )
            }
            if let traceContext = payload.traceContext {
                AdminDetailsField(label: "Trace context", value: traceContext)
            }
            if let sender = payload.sender {
                AdminDetailsField(label: "From", value: sender)
            }
            if let recipient = payload.recipient {
                AdminDetailsField(label: "To", value: recipient)
            }
            if let subject = payload.subject {
                AdminDetailsField(label: "Subject", value: subject)
            }
            if let message = payload.message {
                AdminDetailsField(label: "Message", value: message)
            }
            AdminDetailsField(label: "Payload", value: job.payload)
            Div {
                AdminNavigationButton(
                    "Back to worker jobs",
                    href: "/admin/system/jobs/"
                )
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
