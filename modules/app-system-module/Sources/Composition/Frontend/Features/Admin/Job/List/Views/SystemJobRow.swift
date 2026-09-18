import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemJobRow: Component {
    let job: Components.Schemas.SystemJobSchema
    let permissions: NewAdminListActions

    private var rowActions: [NewAdminListRowActions.Action] {
        [
            .init(
                "View",
                href: SystemJobRoutes.details(RouterPath(job.id)).description,
                style: .ghost(.primary),
                permission: SystemPermissions.Jobs.read
            )
        ]
    }

    func html(context: inout BuilderContext) -> Tr {
        let payload = SystemJobPayload(job: job)
        return Tr {
            Td(payload.name)
                .data("label", "Job")
            Td(payload.parameterSummary.emptyToNil ?? "—")
                .data("label", "Parameters")
            Td {
                context.build(statusChip(job.status))
            }
                .data("label", "Status")
            context.build(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: rowActions,
                    permissions: permissions
                )
            )
        }
    }

    private func statusChip(_ status: Int) -> NewAdminChip {
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
}
