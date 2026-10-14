import FeatherAdmin
import FeatherContracts
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
        let key: String
        let value: String
        let actions: [AdminListRowActions.Action]

        init(
            variable: Components.Schemas.SystemVariableListItemSchema,
            returnTo: String
        ) {
            self.id = variable.id
            self.key = variable.key
            self.value = variable.value
            self.actions = [
                .init(
                    "View",
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
            ]
        }
    }

    let state: State
    let permissions: AdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(SystemPermissions.Variables.delete) {
                context.build(AdminListRowCheckbox(id: state.id))
            }
            Td(state.key)
                .data("label", "Key")
                .data("remove-label", "true")
            Td(state.value.emptyToNil == nil ? "—" : state.value)
                .data("label", "Value")
            context.build(
                AdminListRowActions(
                    label: "Actions",
                    actions: state.actions,
                    permissions: permissions
                )
            )
        }
    }
}
