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

    func html(context: inout RenderContext) -> Tr {
        let payload = SystemJobPayload(job: job)
        return Tr {
            Td(payload.name)
                .data("label", "Job")
                .columnWidth(percent: 30)
            Td(payload.parameterSummary.emptyToNil ?? "—")
                .data("label", "Parameters")
            Td(statusLabel(job.status))
                .data("label", "Status")
                .columnWidth(percent: 20)
            context.render(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: rowActions,
                    permissions: permissions
                )
            )
        }
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
