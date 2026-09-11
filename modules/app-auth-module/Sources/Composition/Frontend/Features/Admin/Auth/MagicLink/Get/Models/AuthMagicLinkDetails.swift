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

struct AuthMagicLinkDetails: Component {
    struct State {
        let link: AuthMagicLinkDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("User magic link details")
            context.render(AdminDetailsField(label: "ID", value: state.link.id))
            context.render(AdminDetailsField(
                label: "Credential ID",
                value: state.link.credentialId
            ))
            context.render(AdminDetailsField(
                label: "Persistent",
                value: state.link.isPersistent ? "Yes" : "No"
            ))
            Div {
                context.render(AdminNavigationButton(
                    "Edit magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/edit/"
                ))
                context.render(AdminNavigationButton(
                    "Remove magic link",
                    href: "/admin/auth/magic-links/\(state.link.id)/remove/",
                    classes: ["danger"]
                ))
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
