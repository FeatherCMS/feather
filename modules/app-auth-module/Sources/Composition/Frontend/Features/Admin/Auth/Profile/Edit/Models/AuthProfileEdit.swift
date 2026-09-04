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

struct AuthProfileEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        var form: AuthProfileForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Edit profile")
            if state.isEdited {
                P("Profile edited successfully.").class("success")
            }

            AuthProfileForm(
                state: state.form,
                action: "/admin/auth/profile/edit/",
                submitLabel: "Edit profile"
            ).html()
        }
        .class("cms-section")
    }
}
