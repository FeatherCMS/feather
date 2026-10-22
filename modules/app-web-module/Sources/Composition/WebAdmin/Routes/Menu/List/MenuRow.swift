import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

struct MenuRow: Component {
    struct State: Sendable {
        let id: String
        let key: String
        let name: String
        let actions: [AdminListRowActions.Action]

        init(menu: Components.Schemas.MenuQueryItemSchema, returnTo: String) {
            self.id = menu.id
            self.key = menu.key
            self.name = menu.name
            self.actions = [
                .init(
                    "View",
                    href: MenuRoutes.details(RouterPath(menu.id))
                        .description,
                    style: .ghost(.primary),
                    permission: WebModule.Permissions.Menus.read
                ),
                .init(
                    "Edit",
                    href: MenuRoutes.edit(RouterPath(menu.id)).description,
                    style: .ghost(.secondary),
                    permission: WebModule.Permissions.Menus.update
                ),
            ]
        }
    }

    let state: State
    let permissions: AdminListActions

    init(
        menu: Components.Schemas.MenuQueryItemSchema,
        permissions: AdminListActions,
        returnTo: String
    ) {
        self.state = .init(menu: menu, returnTo: returnTo)
        self.permissions = permissions
    }

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(WebModule.Permissions.Menus.delete) {
                context.build(AdminListRowCheckbox(id: state.id))
            }
            Td(state.key).data("label", "Key")
            Td(state.name).data("label", "Name")
            context.build(
                AdminListRowActions(
                    label: "Actions",
                    actions: state.actions,
                    permissions: permissions
                )
            )
        }
    }
}
