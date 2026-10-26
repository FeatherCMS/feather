import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Credential.Remove {
    struct Confirmation: WebComponents.Component {
        struct State {
            let item: AdminRemoveItemContext
            let identityId: String
            let breadcrumb: [AdminBreadcrumb.Link]
            let nonceToken: String?
            let routes: Credential.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove user credential",
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
