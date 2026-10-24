import FeatherWebAdmin
import HTML
import Hummingbird
import UserAdminAPI
import UserModule
import WebBuilders
import WebComponents

extension Role.List {
    struct Row: WebComponents.Component {
        let routes: Role.Router.Routes
        let role: Components.Schemas.UserRoleQueryItemSchema
        let permissions: AdminListActions

        func html(context: inout BuilderContext) -> Tr {
            Tr {
                if permissions.allows(Role.Permissions.delete) {
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
                                href: routes.detailsPath(role.id)
                                    .description,
                                style: .ghost(.primary),
                                permission: Role.Permissions.read
                            ),
                            .init(
                                "Edit",
                                href: routes.editPath(role.id)
                                    .description,
                                style: .ghost(.secondary),
                                permission: Role.Permissions.update
                            ),
                        ],
                        permissions: permissions
                    )
                )
            }
        }
    }
}
