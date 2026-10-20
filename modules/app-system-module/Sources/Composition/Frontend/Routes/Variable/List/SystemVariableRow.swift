import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemModule
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
            returnTo: String,
            routes: WebAdmin.System.Variable.Router.Routes
        ) {
            self.id = variable.id
            self.key = variable.key
            self.value = variable.value
            self.actions = [
                .init(
                    "View",
                    href: routes.detailsPath(variable.key),
                    style: .ghost(.primary),
                    permission: SystemModule.Variable.Permissions.read
                ),
                .init(
                    "Edit",
                    href: routes.editPath(variable.key),
                    style: .ghost(.secondary),
                    permission: SystemModule.Variable.Permissions.update
                ),
            ]
        }
    }

    let state: State
    let permissions: AdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(SystemModule.Variable.Permissions.delete) {
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
