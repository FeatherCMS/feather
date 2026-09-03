import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AuthMagicLinkConfirmation: Component {

    struct State {
        let id: String
        let credentialId: String
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
                    .init(
                        prefix: "Identity email ID: ",
                        value: state.credentialId
                    )
                ],
                submitLabel: "Remove magic link",
                actionURL: "/admin/auth/magic-links/\(state.id)/remove/",
                cancelURL: "/admin/auth/magic-links/"
            )
        )
    }
}
