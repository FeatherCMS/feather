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

struct AuthCredentialAdd: Leaf {
    struct State {
        let form: AuthCredentialForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Add user credential")
            AuthCredentialForm(
                state: state.form,
                action: "/admin/auth/credentials/add/",
                submitLabel: "Add credential",
                removeHref: nil
            ).renderHTML()
        }
        .class("cms-section")
    }
}
