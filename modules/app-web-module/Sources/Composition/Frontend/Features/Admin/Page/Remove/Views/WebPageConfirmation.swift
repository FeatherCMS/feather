import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebPageConfirmation: Component {

    struct State {
        let id: String
        let source: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove page",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.source],
                action: WebPageRoutes.details(RouterPath(state.id))
                    .appendingPath(RouterPath("remove")).description,
                cancel: WebPageRoutes.list.description,
                submitLabel: "Remove page"
            )
        )
    }
}
