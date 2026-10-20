import CSS
import FeatherAdmin
import FeatherModuleKit
import Foundation
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemModule
import WebBuilders
import WebComponents

struct SystemJobDetailsView: Component {
    struct State {
        let job: SystemJobDetailsModel
        let routes: Job.Router.Routes
    }

    let state: State

    func selectors() -> [any CSS.Selector] {
        [
            Class("system-job-details-payload") {
                Margin(0)
                WhiteSpace(.preWrap)
                OverflowWrap(.anywhere)
                OverflowX(.auto)
            }
        ]
    }

    func html(context: inout BuilderContext) -> Section {
        let job = state.job.job
        let payload = SystemJobPayload(job: job)
        return Section {
            context.build(
                AdminDetailView(
                    breadcrumb: state.routes.breadcrumb,
                    pageHeader: .primary(
                        title: "Worker job details",
                        description: "Inspect the selected worker job."
                    ),
                    fields: [
                        .init(
                            label: "Job",
                            value: payload.name.emptyToNil ?? "—"
                        ),
                        .init(
                            label: "Queue",
                            value: job.queueName.emptyToNil ?? "—"
                        ),
                        .init(label: "Status", value: statusLabel(job.status)),
                        .init(
                            label: "Worker",
                            value: job.workerId?.emptyToNil ?? "—"
                        ),
                        .init(
                            label: "Last modified",
                            value: String(describing: job.lastModified)
                        ),
                        .init(
                            label: "Queued at",
                            value: payload.queuedAt ?? "—"
                        ),
                        .init(label: "Attempt", value: payload.attempt ?? "—"),
                        .init(
                            label: "Next scheduled at",
                            value: payload.nextScheduledAt ?? "—"
                        ),
                        .init(
                            label: "Trace context",
                            value: payload.traceContext ?? "—"
                        ),
                        .init(label: "From", value: payload.sender ?? "—"),
                        .init(label: "To", value: payload.recipient ?? "—"),
                        .init(label: "Subject", value: payload.subject ?? "—"),
                        .init(label: "Message", value: payload.message ?? "—"),
                    ]
                )
            )
            Div {
                P("Payload").class("admin-detail-view-field-label")
                Pre(escapedPayload(job.payload.emptyToNil ?? "—"))
                    .class("system-job-details-payload")
            }
            .class("admin-detail-view-field")
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

    private func escapedPayload(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
