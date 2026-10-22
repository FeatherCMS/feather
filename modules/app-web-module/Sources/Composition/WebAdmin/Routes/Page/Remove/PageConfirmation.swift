import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import Builders
import Components

struct PageConfirmation: Component {

    struct State {
        let id: String
        let source: String
        let breadcrumb: [AdminBreadcrumb.Link]
        let nonceToken: String
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            AdminRemoveConfirmation(
                header: .primary(
                    title: "Remove page",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.source],
                action: PageRoutes.details(RouterPath(state.id))
                    .appendingPath(RouterPath("remove")).description,
                submit: .init(label: "Remove page", style: .destructive),
                nonceToken: state.nonceToken,
                hiddenFields: [.init(name: "ids", value: state.id)]
            )
        )
    }
}
