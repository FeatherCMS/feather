import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import SystemAdminAPI
import SystemModule
import WebBuilders
import WebComponents

struct SystemJobRow: Component {
    let job: Components.Schemas.SystemJobQueryItemSchema
    let permissions: AdminListActions
    let routes: Job.Router.Routes

    private var rowActions: [AdminListRowActions.Action] {
        [
            .init(
                "View",
                href: routes.detailsPath(job.id),
                style: .ghost(.primary),
                permission: SystemModule.Job.Permissions.read
            )
        ]
    }

    func html(context: inout BuilderContext) -> Tr {
        let payload = SystemJobPayload(payload: job.payload)
        return Tr {
            Td(payload.name)
                .data("label", "Job")
            Td(
                htmlEscaped(
                    truncatedParameterSummary(payload.parameterSummary)
                )
                .emptyToNil ?? "—"
            )
            .data("label", "Parameters")
            Td {
                context.build(statusChip(job.status))
            }
            .data("label", "Status")
            context.build(
                AdminListRowActions(
                    label: "Actions",
                    actions: rowActions,
                    permissions: permissions
                )
            )
        }
    }

    private func statusChip(_ status: Int) -> AdminChip {
        switch status {
        case 0: .init(label: "Pending", color: .blue)
        case 1: .init(label: "Processing", color: .yellow)
        case 2: .init(label: "Failed", color: .red)
        case 3: .init(label: "Cancelled", color: .gray)
        case 4: .init(label: "Paused", color: .purple)
        case 5: .init(label: "Completed", color: .green)
        default: .init(label: "Unknown (\(status))", color: .gray)
        }
    }

    private func htmlEscaped(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }

    private func truncatedParameterSummary(_ value: String) -> String {
        guard value.count > 200 else { return value }
        return String(value.prefix(199)) + "…"
    }
}
