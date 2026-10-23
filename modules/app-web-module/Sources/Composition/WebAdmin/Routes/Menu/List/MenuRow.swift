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

        init(
            menu: Components.Schemas.MenuQueryItemSchema,
            returnTo: String,
            routes: WebModule.Menu.Router.Routes
        ) {
            self.id = menu.id
            self.key = menu.key
            self.name = menu.name
            self.actions = [
                .init(
                    "View",
                    href: routes.detailsPath(menu.id),
                    style: .ghost(.primary),
                    permission: WebModule.Permissions.Menus.read
                ),
                .init(
                    "Edit",
                    href: routes.editPath(menu.id),
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
        returnTo: String,
        routes: WebModule.Menu.Router.Routes
    ) {
        self.state = .init(menu: menu, returnTo: returnTo, routes: routes)
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
