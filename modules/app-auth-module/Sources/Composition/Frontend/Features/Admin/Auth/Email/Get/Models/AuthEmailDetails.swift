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

struct AuthEmailDetails: Component {
    struct State {
        let link: AuthEmailDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("User email details")
            AdminDetailsField(label: "ID", value: state.link.id)
            AdminDetailsField(
                label: "Identity ID",
                value: state.link.identityId
            )
            Div {
                AdminNavigationButton(
                    "Edit email",
                    href: "/admin/auth/emails/\(state.link.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove email",
                    href: "/admin/auth/emails/\(state.link.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
