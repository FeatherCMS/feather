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

struct AuthMagicLinkAdd: Leaf {

    struct State {
        let form: AuthMagicLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Add user magic link")
            AuthMagicLinkForm(
                state: state.form,
                action: "/admin/auth/magic-links/add/",
                submitLabel: "Add magic link"
            ).html()
        }
        .class("cms-section")
    }
}
