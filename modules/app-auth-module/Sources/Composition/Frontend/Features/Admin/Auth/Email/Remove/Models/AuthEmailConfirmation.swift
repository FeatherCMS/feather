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

struct AuthEmailConfirmation: Leaf {

    struct State {
        let id: String
        let identityId: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove user email",
                message:
                    "Are you sure you want to remove this user email? This action cannot be undone.",
                details: [
                    .init(
                        prefix: "Auth email ID: ",
                        value: state.identityId
                    )
                ],
                submitLabel: "Remove email",
                actionURL: "/admin/auth/emails/\(state.id)/remove/",
                cancelURL: "/admin/auth/emails/"
            )
        ).renderHTML()
    }
}
