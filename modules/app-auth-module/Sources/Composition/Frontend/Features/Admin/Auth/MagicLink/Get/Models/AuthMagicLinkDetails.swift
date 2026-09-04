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

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("User magic link details")
            AdminDetailsField(label: "ID", value: state.link.id).renderHTML()
            AdminDetailsField(
                label: "Credential ID",
                value: state.link.credentialId
            ).renderHTML()
            AdminDetailsField(
                label: "Persistent",
                value: state.link.isPersistent ? "Yes" : "No"
            ).renderHTML()
            Div {
                AdminNavigationButton(
                    "Edit magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
