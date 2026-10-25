import AuthModule
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Email.Remove {
    struct Confirmation: WebComponents.Component {
        struct State {
            let item: AdminRemoveItemContext
            let identityId: String
            let breadcrumb: [AdminBreadcrumb.Link]
            let nonceToken: String?
            let routes: Email.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove user email",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [state.item.label],
                    action: state.routes.removePath(state.item.id),
                    nonceToken: state.nonceToken
                )
            )
        }
    }
}
