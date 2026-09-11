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

struct AuthMagicLinkAdd: Component {

    struct State {
        let form: AuthMagicLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add user magic link")
            context.render(AuthMagicLinkForm(
                state: state.form,
                action: "/admin/auth/magic-links/add/",
                submitLabel: "Add magic link"
            ))
        }
        .class("cms-section")
    }
}
