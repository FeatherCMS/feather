import SystemModule
import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SystemAdminAPI
import WebBuilders
import WebComponents

struct SystemPermissionRow: Component {
    let permission: Components.Schemas.SystemPermissionListItemSchema
    let actions: AdminListActions
    let returnTo: String

    private var rowActions: [AdminListRowActions.Action] {
        [
            .init(
                "View",
                href: SystemPermissionRoutes.details(RouterPath(permission.key))
                    .description,
                style: .ghost(.primary),
                permission: SystemModule.Permission.Permissions.read
            ),
            .init(
                "Edit",
                href: SystemPermissionRoutes.edit(RouterPath(permission.key))
                    .description,
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
