import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct UserInvitationConfirmation: Component {

    struct State {
        let id: String
        let email: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
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
                actionURL: "/admin/user/invitations/\(state.id)/remove/",
                cancelURL: "/admin/user/invitations/"
            )
        )
    }
}
