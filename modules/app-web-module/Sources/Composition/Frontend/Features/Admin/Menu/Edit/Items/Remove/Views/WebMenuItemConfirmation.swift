import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemConfirmation: Component {

    struct State {
        let menuId: String
        let id: String
        let label: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String
        let origin: WebMenuItemRoutes.RemoveOrigin
    }

    let state: State

    func html(context: inout BuilderContext) -> Section {
        context.build(
            NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Edit menu",
                    description: "Update the navigation menu configuration."
                ),
                selectedItems: [state.label],
                action:
                    WebMenuItemRoutes.itemRemove(
                        RouterPath(state.menuId),
                        RouterPath(state.id),
                        origin: state.origin
                    ),
                submit: .init(label: "Remove item", style: .destructive),
                nonceToken: state.nonceToken,
                hiddenFields: [.init(name: "ids", value: state.id)],
                relationshipGroupHeader: .init(
                    title: "Remove item",
                    description: "This action cannot be undone.",
                    level: 2,
                    showSeparator: true
                )
            )
        )
    }
}
