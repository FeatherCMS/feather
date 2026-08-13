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

struct AuthMagicLinkDetails: Component {
    struct State {
        let link: AuthMagicLinkDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("User magic link details")
            AdminDetailsField(label: "ID", value: state.link.id)
            AdminDetailsField(
                label: "Credential ID",
                value: state.link.credentialId
            )
            AdminDetailsField(
                label: "Persistent",
                value: state.link.isPersistent ? "Yes" : "No"
            )
            Div {
                AdminNavigationButton(
                    "Edit magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
