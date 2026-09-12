import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebBuilders
import WebComponents

struct SystemJobDetailsView: Component {
    struct State {
        let job: SystemJobDetailsModel
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        let job = state.job.job
        let payload = SystemJobPayload(job: job)
        return context.render(
            NewAdminDetailView(
                breadcrumb: SystemJobRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Worker job details",
                    description: "Inspect the selected worker job."
                ),
                fields: [
                    .init(label: "Job", value: payload.name.emptyToNil ?? "—"),
                    .init(label: "ID", value: job.id),
                    .init(label: "Queue", value: job.queueName.emptyToNil ?? "—"),
                    .init(label: "Status", value: statusLabel(job.status)),
                    .init(label: "Worker", value: job.workerId?.emptyToNil ?? "—"),
                    .init(label: "Last modified", value: String(describing: job.lastModified)),
                    .init(label: "Queued at", value: payload.queuedAt ?? "—"),
                    .init(label: "Attempt", value: payload.attempt ?? "—"),
                    .init(label: "Next scheduled at", value: payload.nextScheduledAt ?? "—"),
                    .init(label: "Trace context", value: payload.traceContext ?? "—"),
                    .init(label: "From", value: payload.sender ?? "—"),
                    .init(label: "To", value: payload.recipient ?? "—"),
                    .init(label: "Subject", value: payload.subject ?? "—"),
                    .init(label: "Message", value: payload.message ?? "—"),
                    .init(label: "Payload", value: job.payload.emptyToNil ?? "—"),
                ]
            )
        )
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
