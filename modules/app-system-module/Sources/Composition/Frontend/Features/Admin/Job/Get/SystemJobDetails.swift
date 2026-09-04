import FeatherAdmin
import HTML
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemJobDetails: Leaf {
    let job: Components.Schemas.SystemJobSchema
    let breadcrumb: AdminBreadcrumb.State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).renderHTML()
            H1("Worker job details")
            let payload = SystemJobPayload(job: job)
            AdminDetailsField(label: "Job", value: payload.name).renderHTML()
            AdminDetailsField(label: "ID", value: job.id).renderHTML()
            AdminDetailsField(label: "Queue", value: job.queueName).renderHTML()
            AdminDetailsField(label: "Status", value: statusLabel(job.status)).renderHTML()
            AdminDetailsField(label: "Worker", value: job.workerId ?? "—").renderHTML()
            AdminDetailsField(
                label: "Last modified",
                value: String(describing: job.lastModified)
            ).renderHTML()
            if let queuedAt = payload.queuedAt {
                AdminDetailsField(label: "Queued at", value: queuedAt).renderHTML()
            }
            if let attempt = payload.attempt {
                AdminDetailsField(label: "Attempt", value: attempt).renderHTML()
            }
            if let nextScheduledAt = payload.nextScheduledAt {
                AdminDetailsField(
                    label: "Next scheduled at",
                    value: nextScheduledAt
                ).renderHTML()
            }
            if let traceContext = payload.traceContext {
                AdminDetailsField(label: "Trace context", value: traceContext).renderHTML()
            }
            if let sender = payload.sender {
                AdminDetailsField(label: "From", value: sender).renderHTML()
            }
            if let recipient = payload.recipient {
                AdminDetailsField(label: "To", value: recipient).renderHTML()
            }
            if let subject = payload.subject {
                AdminDetailsField(label: "Subject", value: subject).renderHTML()
            }
            if let message = payload.message {
                AdminDetailsField(label: "Message", value: message).renderHTML()
            }
            AdminDetailsField(label: "Payload", value: job.payload).renderHTML()
            Div {
                AdminNavigationButton(
                    "Back to worker jobs",
                    href: "/admin/system/jobs/"
                ).renderHTML()
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
