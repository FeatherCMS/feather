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

extension WebModule.Menu.Remove {
    struct Confirmation: Component {

        struct State {
            let id: String
            let source: String
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: WebModule.Menu.Router.Routes
            let nonceToken: String
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove menu",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [state.source],
                    action: state.routes.detailsRemovePath(state.id),
                    submit: .init(label: "Remove menu", style: .destructive),
                    nonceToken: state.nonceToken,
                    hiddenFields: [.init(name: "ids", value: state.id)]
                )
            )
        }
    }
}
