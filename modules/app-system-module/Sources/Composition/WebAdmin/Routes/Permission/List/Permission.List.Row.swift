import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SystemAdminAPI
import SystemModule
import WebBuilders
import WebComponents

extension Permission.List {
    struct Row: Component {
        let permission: Components.Schemas.SystemPermissionListItemSchema
        let actions: AdminListActions
        let returnTo: String
        let routes: Permission.Router.Routes

        private var rowActions: [AdminListRowActions.Action] {
            [
                .init(
                    "View",
                    href: routes.detailsPath(permission.id),
                    style: .ghost(.primary),
                    permission: SystemModule.Permission.Permissions.read
                ),
                .init(
                    "Edit",
                    href: routes.editPath(permission.id),
                    style: .ghost(.secondary),
                    permission: SystemModule.Permission.Permissions.update
                ),
            ]
        }

        func html(context: inout BuilderContext) -> Tr {
            Tr {
                if actions.allows(SystemModule.Permission.Permissions.delete) {
                    context.build(AdminListRowCheckbox(id: permission.id))
                }
                Td(permission.key)
                    .data("label", "Key")
                    .data("remove-label", "true")
                Td(permission.name?.emptyToNil ?? "—")
                    .data("label", "Name")
                context.build(
                    AdminListRowActions(
                        label: "Actions",
                        actions: rowActions,
                        permissions: actions
                    )
                )
            }
        }
    }
}
