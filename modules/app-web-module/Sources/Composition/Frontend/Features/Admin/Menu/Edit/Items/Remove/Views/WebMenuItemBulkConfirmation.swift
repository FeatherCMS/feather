import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemBulkConfirmation: Component {
    struct State {
        let menuId: String
        let page: Int
        let search: String?
        let items: [NewAdminRemoveItemContext]
        let nonceToken: String
    }

    let state: State

    func html(context: inout BuilderContext) -> Section {
        context.build(
            NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove selected menu items",
                    description: "This action cannot be undone."
                ),
                selectedItems: state.items.map(\.label),
                action:
                    WebMenuItemRoutes.remove(
                        RouterPath(state.menuId)
                    )
                    .description,
                nonceToken: state.nonceToken,
                hiddenFields: state.items.map {
                    .init(name: "ids", value: $0.id)
                }
            )
        )
    }
}
