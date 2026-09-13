import FeatherAdmin
import HTML
import Hummingbird
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserRoleRow: Component {
    let role: Components.Schemas.UserRoleListItemSchema
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if permissions.allows(UserPermissions.Roles.delete) {
                context.render(NewAdminListRowCheckbox(id: role.id))
            }
            Td(role.name ?? "—").data("label", "Name").columnWidth(percent: 74)
            context.render(
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
