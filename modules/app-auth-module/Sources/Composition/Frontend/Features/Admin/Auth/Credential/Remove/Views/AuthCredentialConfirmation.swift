import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AuthCredentialConfirmation: Component {
    struct State {
        let id: String
        let identityId: String
        let email: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminRemoveConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove user credential",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.email.emptyToNil ?? state.identityId],
                action: "/admin/auth/credentials/\(state.id)/remove/",
                cancel: "/admin/auth/credentials/",
                nonceToken: state.nonceToken
            )
        )
    }
}
