import AccountModule
import FeatherWebAdmin
import SGML
import WebComponents

extension Invitation.Remove {
    struct Confirmation: Component {
        let routes: Invitation.Router.Routes

        struct State {
            let id: String
            let email: String
            let breadcrumb: [AdminBreadcrumb.Link]
            let nonceToken: String?
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove user invitation",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [state.email],
                    action: routes.invitationRemove(state.id) + "/",
                    submit: .init(
                        label: "Remove invitation",
                        style: .destructive
                    ),
                    nonceToken: state.nonceToken
                )
            )
        }
    }
}
