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

struct AuthCredentialEdit: Component {
    struct State {
        let id: String
        let form: AuthCredentialForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Edit user credential")
            context.render(AuthCredentialForm(
                state: state.form,
                action: "/admin/auth/credentials/\(state.id)/edit/",
                submitLabel: "Edit credential",
                removeHref: "/admin/auth/credentials/\(state.id)/remove/"
            ))
        }
        .class("cms-section")
    }
}
