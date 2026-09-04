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

struct AuthEmailAdd: Leaf {

    struct State {
        let form: AuthEmailForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Add user email")
            AuthEmailForm(
                state: state.form,
                action: "/admin/auth/emails/add/",
                submitLabel: "Add email"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
