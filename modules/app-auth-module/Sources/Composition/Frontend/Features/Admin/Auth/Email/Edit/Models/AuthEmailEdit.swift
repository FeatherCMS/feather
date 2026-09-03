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

struct AuthEmailEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AuthEmailForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit user email")
            if state.isEdited { P("User email edited successfully.") }
            AuthEmailForm(
                state: state.form,
                action: "/admin/auth/emails/\(state.id)/edit/",
                submitLabel: "Edit email",
                removeHref: "/admin/auth/emails/\(state.id)/remove/",
                removeLabel: "Remove email"
            )
        }
        .class("cms-section")
    }
}
