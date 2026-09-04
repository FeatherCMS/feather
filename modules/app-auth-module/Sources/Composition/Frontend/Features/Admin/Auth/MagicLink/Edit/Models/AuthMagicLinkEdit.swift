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

struct AuthMagicLinkEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AuthMagicLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Edit user magic link")
            if state.isEdited { P("User magic link edited successfully.") }
            AuthMagicLinkForm(
                state: state.form,
                action: "/admin/auth/magic-links/\(state.id)/edit/",
                submitLabel: "Edit magic link",
                removeHref: "/admin/auth/magic-links/\(state.id)/remove/",
                removeLabel: "Remove magic link"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
