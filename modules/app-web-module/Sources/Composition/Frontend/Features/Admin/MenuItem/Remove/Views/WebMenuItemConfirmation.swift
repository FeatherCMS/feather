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
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove item",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.label],
                action: WebMenuItemRoutes.details(
                    RouterPath(state.menuId),
                    RouterPath(state.id)
                ).appendingPath(RouterPath("remove")).description,
                cancel: WebMenuItemRoutes.list(RouterPath(state.menuId))
                    .description,
                submitLabel: "Remove item"
            )
        )
    }
}
