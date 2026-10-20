import FeatherWebAdmin
import HTML
import Hummingbird
import UserAdminAPI
import UserModule
import WebBuilders
import WebComponents

extension Identity.List {
    struct Row: Component {
        let routes: Identity.Router.Routes
        let identity: Components.Schemas.UserIdentityListItemSchema
        let permissions: AdminListActions

        func html(context: inout BuilderContext) -> Tr {
            Tr {
                if permissions.allows(Identity.Permissions.delete) {
                    context.build(AdminListRowCheckbox(id: identity.id))
                }
                Td(identity.id).data("label", "ID")
                Td(identity.name)
                    .data("label", "Name")
                    .data("remove-label", "true")
                Td {
                    context.build(
                        Identity.StatusChip.make(
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
                    AdminListRowActions(
                        label: "Actions",
                        actions: [
                            .init(
                                "View",
                                href: routes.detailsPath(identity.id),
                                style: .ghost(.primary),
                                permission: Identity.Permissions
                                    .read
                            ),
                            .init(
                                "Edit",
                                href: routes.editPath(identity.id),
                                style: .ghost(.secondary),
                                permission: Identity.Permissions
                                    .update
                            ),
                        ],
                        permissions: permissions
                    )
                )
            }
        }
    }
}
