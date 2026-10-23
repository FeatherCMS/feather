import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebDomain
import WebModule

struct MenuItemBulkConfirmation: Component {
    struct State {
        let menuId: String
        let page: Int
        let search: String?
        let items: [AdminRemoveItemContext]
        let nonceToken: String
        let routes: WebModule.Menu.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> Section {
        context.build(
            AdminRemoveConfirmation(
                header: .primary(
                    title: "Remove selected menu items",
                    description: "This action cannot be undone."
                ),
                selectedItems: state.items.map(\.label),
                action: state.routes.itemsRemovePath(state.menuId),
                nonceToken: state.nonceToken,
                hiddenFields: state.items.map {
                    .init(name: "ids", value: $0.id)
                }
            )
        )
    }
}
