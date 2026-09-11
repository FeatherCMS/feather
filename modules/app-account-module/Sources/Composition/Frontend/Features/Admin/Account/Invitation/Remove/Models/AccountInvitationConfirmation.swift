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
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            AdminConfirmationDialog(
                state: .init(
                    breadcrumb: state.breadcrumb,
                    title: "Remove user invitation",
                    message:
                        "Are you sure you want to remove this user invitation? This action cannot be undone.",
                    details: [
                        .init(prefix: "Email: ", value: state.email)
                    ],
                    submitLabel: "Remove invitation",
                    actionURL: "/admin/account/invitations/\(state.id)/remove/",
                    cancelURL: "/admin/account/invitations/"
                )
            )
        )
    }
}
