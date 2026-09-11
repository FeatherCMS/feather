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
import WebBuilders
import WebComponents

struct AuthMagicLinkEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AuthMagicLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit user magic link")
            if state.isEdited { P("User magic link edited successfully.") }
            context.render(
                AuthMagicLinkForm(
                    state: state.form,
                    action: "/admin/auth/magic-links/\(state.id)/edit/",
                    submitLabel: "Edit magic link",
                    removeHref: "/admin/auth/magic-links/\(state.id)/remove/",
                    removeLabel: "Remove magic link"
                )
            )
        }
        .class("cms-section")
    }
}
