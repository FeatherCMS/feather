import FeatherAdmin
import HTML
import Hummingbird
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserRoleRow: Component {
    let role: Components.Schemas.UserRoleListItemSchema
    let permissions: AdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(UserPermissions.Roles.delete) {
                context.build(AdminListRowCheckbox(id: role.id))
            }
            Td(role.name ?? "—")
                .data("label", "Name")
                .data("remove-label", "true")
            context.build(
                AdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href: UserRoleRoutes.details(RouterPath(role.id))
                                .description,
                            style: .ghost(.primary),
                            permission: UserPermissions.Roles.read
                        ),
                        .init(
                            "Edit",
                            href: UserRoleRoutes.edit(RouterPath(role.id))
                                .description,
                            style: .ghost(.secondary),
                            permission: UserPermissions.Roles.update
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
