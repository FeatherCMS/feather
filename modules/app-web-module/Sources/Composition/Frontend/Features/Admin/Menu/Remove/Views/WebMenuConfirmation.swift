import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuConfirmation: Component {

    struct State {
        let id: String
        let source: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove menu",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.source],
                action: WebMenuRoutes.details(RouterPath(state.id))
                    .appendingPath(RouterPath("remove")).description,
                cancel: WebMenuRoutes.list.description,
                submitLabel: "Remove menu"
            )
        )
    }
}
