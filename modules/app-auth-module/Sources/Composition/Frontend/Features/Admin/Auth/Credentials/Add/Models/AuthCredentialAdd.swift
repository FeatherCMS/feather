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

struct AuthCredentialAdd: Component {
    struct State {
        let form: AuthCredentialForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Add user credential")
            AuthCredentialForm(
                state: state.form,
                action: "/admin/auth/credentials/add/",
                submitLabel: "Add credential",
                removeHref: nil
            )
        }
        .class("cms-section")
    }
}
