import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import Builders
import Components

struct MenuItemConfirmation: Component {

    struct State {
        let menuId: String
        let id: String
        let label: String
        let breadcrumb: [AdminBreadcrumb.Link]
        let nonceToken: String
        let origin: MenuItemRoutes.RemoveOrigin
    }

    let state: State

    func html(context: inout BuilderContext) -> Section {
        context.build(
            AdminRemoveConfirmation(
                header: .primary(
                    title: "Remove menu item",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.label],
                action:
                    MenuItemRoutes.itemRemove(
                        RouterPath(state.menuId),
                        RouterPath(state.id),
                        origin: state.origin
                    ),
                submit: .init(label: "Remove item", style: .destructive),
                nonceToken: state.nonceToken,
                hiddenFields: [.init(name: "ids", value: state.id)]
            )
        )
    }
}
