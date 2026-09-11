import FeatherAdmin
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemVariableRow: Component {
    struct State: Sendable {
        let id: String
        let name: String
        let value: String
        let actions: [NewAdminListRowActions.Action]

        init(variable: Components.Schemas.SystemVariableListItemSchema) {
            self.id = variable.id
            self.name = variable.name ?? ""
            self.value = variable.value
            self.actions = [
                .init(
                    "Details",
                    href: SystemVariableRoutes.details(RouterPath(variable.id))
                        .description,
                    style: .ghost(.primary),
                    permission: SystemPermissions.Variables.read
                ),
                .init(
                    "Edit",
                    href: SystemVariableRoutes.edit(RouterPath(variable.id))
                        .description,
                    style: .ghost(.secondary),
                    permission: SystemPermissions.Variables.update
                ),
                .init(
                    "Remove",
                    href: SystemVariableRoutes.remove(variable.id),
                    style: .destructive,
                    permission: SystemPermissions.Variables.delete
                ),
            ]
        }
    }

    let state: State
    let permissions: ListActions

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if permissions.allows(SystemPermissions.Variables.delete) {
                context.render(NewAdminListRowCheckbox(id: state.id))
            }
            Td(state.name).data("label", "Name").columnWidth(percent: 50)
            Td(state.value).data("label", "Value").columnWidth(percent: 50)
            context.render(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: state.actions,
                    permissions: permissions
                )
            )
        }
    }
}
