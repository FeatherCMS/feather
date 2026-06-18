import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct AuthMagicLinkConfirmation: Component {

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
                title: "Remove user magic link",
                message:
                    "Are you sure you want to remove this user magic link? This action cannot be undone.",
                details: [
                    .init(prefix: "Email: ", value: state.email)
                ],
                submitLabel: "Remove magic link",
                actionURL: "/admin/auth/magic-links/\(state.id)/remove/",
                cancelURL: "/admin/auth/magic-links/"
            )
        )
    }
}
