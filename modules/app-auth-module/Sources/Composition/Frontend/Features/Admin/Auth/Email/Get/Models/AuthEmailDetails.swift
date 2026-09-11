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

struct AuthEmailDetails: Component {
    struct State {
        let link: AuthEmailDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("User email details")
            context.render(AdminDetailsField(label: "ID", value: state.link.id))
            context.render(AdminDetailsField(
                label: "Identity ID",
                value: state.link.identityId
            ))
            Div {
                context.render(AdminNavigationButton(
                    "Edit email",
                    href: "/admin/auth/emails/\(state.link.id)/edit/"
                ))
                context.render(AdminNavigationButton(
                    "Remove email",
                    href: "/admin/auth/emails/\(state.link.id)/remove/",
                    classes: ["danger"]
                ))
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
