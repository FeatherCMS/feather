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
                href: SystemPermissionRoutes.removeFromList(permission.id),
                style: .destructive,
                permission: SystemPermissions.Permissions.delete
            ),
        ]
    }

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if actions.allows(SystemPermissions.Permissions.delete) {
                context.render(NewAdminListRowCheckbox(id: permission.id))
            }
            Td(permission.key)
                .data("label", "Key")
                .columnWidth(percent: 50)
            Td(permission.name?.emptyToNil ?? "—")
                .data("label", "Name")
                .columnWidth(percent: 50)
            context.render(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: rowActions,
                    permissions: actions
                )
            )
        }
    }
}
