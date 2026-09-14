import AccountAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationConfirmation: Component {

    struct State {
        let id: String
        let email: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String?
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Remove user invitation",
                    description: "This action cannot be undone."
                ),
                selectedItems: [state.email],
                action: "/admin/account/invitations/\(state.id)/remove/",
                cancel: "/admin/account/invitations/",
                submitLabel: "Remove invitation",
                nonceToken: state.nonceToken
            )
        )
    }
}
