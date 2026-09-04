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
import WebComponents
import WebBuilders

struct AuthCredentialConfirmation: Leaf {
    struct State {
        let id: String
        let identityId: String
        let email: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove user credential",
                message:
                    "Are you sure you want to remove this user credential? This action cannot be undone.",
                details: [.init(prefix: "Email: ", value: state.email)],
                submitLabel: "Remove credential",
                actionURL: "/admin/auth/credentials/\(state.id)/remove/",
                cancelURL: "/admin/auth/credentials/"
            )
        ).html()
    }
}
