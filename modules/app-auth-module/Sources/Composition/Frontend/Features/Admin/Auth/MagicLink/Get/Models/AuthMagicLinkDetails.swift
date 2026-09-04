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

struct AuthMagicLinkDetails: Leaf {
    struct State {
        let link: AuthMagicLinkDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("User magic link details")
            AdminDetailsField(label: "ID", value: state.link.id).html()
            AdminDetailsField(
                label: "Credential ID",
                value: state.link.credentialId
            ).html()
            AdminDetailsField(
                label: "Persistent",
                value: state.link.isPersistent ? "Yes" : "No"
            ).html()
            Div {
                AdminNavigationButton(
                    "Edit magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/edit/"
                ).html()
                AdminNavigationButton(
                    "Remove magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/remove/",
                    classes: ["danger"]
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
