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

struct AuthEmailDetails: Leaf {
    struct State {
        let link: AuthEmailDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("User email details")
            AdminDetailsField(label: "ID", value: state.link.id).renderHTML()
            AdminDetailsField(
                label: "Identity ID",
                value: state.link.identityId
            ).renderHTML()
            Div {
                AdminNavigationButton(
                    "Edit email",
                    href: "/admin/auth/emails/\(state.link.id)/edit/"
                ).renderHTML()
                AdminNavigationButton(
                    "Remove email",
                    href: "/admin/auth/emails/\(state.link.id)/remove/",
                    classes: ["danger"]
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
