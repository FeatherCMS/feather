import FeatherAdmin
import HTML
import Hummingbird
import UserAdminAPI
import UserContracts
import WebComponents
import WebBuilders

struct UserRoleRow: Component {
    let role: Components.Schemas.UserRoleListItemSchema
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(UserPermissions.Roles.delete) {
                context.build(NewAdminListRowCheckbox(id: role.id))
            }
            Td(role.name ?? "—").data("label", "Name")
            context.build(
                NewAdminListRowActions(
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
                        .init(
                            "Remove",
                            href: UserRoleRoutes.remove(RouterPath(role.id))
                                .description,
                            style: .destructive,
                            permission: UserPermissions.Roles.delete
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
