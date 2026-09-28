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
        let nonceToken: String
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                header: .primary(
                    title: "Remove page",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.source],
                action: WebPageRoutes.details(RouterPath(state.id))
                    .appendingPath(RouterPath("remove")).description,
                submit: .init(label: "Remove page", style: .destructive),
                nonceToken: state.nonceToken,
                hiddenFields: [.init(name: "ids", value: state.id)]
            )
        )
    }
}
