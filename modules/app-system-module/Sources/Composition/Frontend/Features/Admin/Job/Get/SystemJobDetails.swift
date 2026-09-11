import FeatherAdmin
import HTML
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemJobDetails: Component {
    let job: Components.Schemas.SystemJobSchema
    let breadcrumb: AdminBreadcrumb.State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: breadcrumb))
            H1("Worker job details")
            let payload = SystemJobPayload(job: job)
            context.render(AdminDetailsField(label: "Job", value: payload.name))
            context.render(AdminDetailsField(label: "ID", value: job.id))
            context.render(AdminDetailsField(label: "Queue", value: job.queueName))
            context.render(AdminDetailsField(label: "Status", value: statusLabel(job.status)))
            context.render(AdminDetailsField(label: "Worker", value: job.workerId ?? "—"))
            context.render(AdminDetailsField(
                label: "Last modified",
                value: String(describing: job.lastModified)
            ))
            if let queuedAt = payload.queuedAt {
                context.render(AdminDetailsField(label: "Queued at", value: queuedAt))
            }
            if let attempt = payload.attempt {
                context.render(AdminDetailsField(label: "Attempt", value: attempt))
            }
            if let nextScheduledAt = payload.nextScheduledAt {
                context.render(AdminDetailsField(
                    label: "Next scheduled at",
                    value: nextScheduledAt
                ))
            }
            if let traceContext = payload.traceContext {
                context.render(AdminDetailsField(label: "Trace context", value: traceContext))
            }
            if let sender = payload.sender {
                context.render(AdminDetailsField(label: "From", value: sender))
            }
            if let recipient = payload.recipient {
                context.render(AdminDetailsField(label: "To", value: recipient))
            }
            if let subject = payload.subject {
                context.render(AdminDetailsField(label: "Subject", value: subject))
            }
            if let message = payload.message {
                context.render(AdminDetailsField(label: "Message", value: message))
            }
            context.render(AdminDetailsField(label: "Payload", value: job.payload))
            Div {
                context.render(AdminNavigationButton(
                    "Back to worker jobs",
                    href: "/admin/system/jobs/"
                ))
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
