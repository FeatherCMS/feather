import FeatherAdmin
import HTML
import Hummingbird
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserIdentityRow: Component {
    let identity: Components.Schemas.UserIdentityListItemSchema
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(UserPermissions.Identities.delete) {
                context.build(NewAdminListRowCheckbox(id: identity.id))
            }
            Td(identity.id).data("label", "ID")
            Td(identity.name).data("label", "Name")
            Td {
                context.build(
                    UserIdentityStatusChip.make(
                        status: identity.status.rawValue
                    )
                )
            }
            .data("label", "Status")
            Td(
                identity.roles.isEmpty
                    ? "No roles assigned"
                    : identity.roles.joined(separator: ", ")
            )
            .data("label", "Roles")
            context.build(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href:
                                UserIdentityRoutes.details(
                                    RouterPath(identity.id)
                                )
                                .description,
                            style: .ghost(.primary),
                            permission: UserPermissions.Identities.read
                        ),
                        .init(
                            "Edit",
                            href:
                                UserIdentityRoutes.edit(RouterPath(identity.id))
                                .description,
                            style: .ghost(.secondary),
                            permission: UserPermissions.Identities.update
                        ),
                        .init(
                            "Remove",
                            href:
                                UserIdentityRoutes.remove(
                                    RouterPath(identity.id)
                                )
                                .description,
                            style: .destructive,
                            permission: UserPermissions.Identities.delete
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
