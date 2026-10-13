import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemPermissionRow: Component {
    let permission: Components.Schemas.SystemPermissionListItemSchema
    let actions: NewAdminListActions
    let returnTo: String

    private var rowActions: [NewAdminListRowActions.Action] {
        [
            .init(
                "View",
                href: SystemPermissionRoutes.details(RouterPath(permission.id))
                    .description,
                style: .ghost(.primary),
                permission: SystemPermissions.Permissions.read
            ),
            .init(
                "Edit",
                href: SystemPermissionRoutes.edit(RouterPath(permission.id))
                    .description,
                style: .ghost(.secondary),
                permission: SystemPermissions.Permissions.update
            ),
            .init(
                "Remove",
                href: NewAdminLocation.remove(
                    path: SystemPermissionRoutes.remove.description,
                    ids: [permission.id],
                    returnTo: returnTo
                ),
                style: .destructive,
                permission: SystemPermissions.Permissions.delete
            ),
        ]
    }

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if actions.allows(SystemPermissions.Permissions.delete) {
                context.build(NewAdminListRowCheckbox(id: permission.id))
            }
            Td(permission.key)
                .data("label", "Key")
            Td(permission.name?.emptyToNil ?? "—")
                .data("label", "Name")
            context.build(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: rowActions,
                    permissions: actions
                )
            )
        }
    }
}
