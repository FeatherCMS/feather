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

extension WebDomain.Menu.Remove {
    struct Confirmation: Component {

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
                    title: "Remove menu",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.source],
                action: MenuRoutes.details(RouterPath(state.id))
                    .appendingPath(RouterPath("remove")).description,
                submit: .init(label: "Remove menu", style: .destructive),
                nonceToken: state.nonceToken,
                hiddenFields: [.init(name: "ids", value: state.id)]
            )
        )
    }
    }
}
