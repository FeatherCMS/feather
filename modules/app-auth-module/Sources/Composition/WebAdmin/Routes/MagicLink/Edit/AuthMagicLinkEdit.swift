import AuthAdminAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AuthMagicLinkEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AuthMagicLinkForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))

            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit user magic link",
                        description: "Update a sign-in magic link."
                    )
                )
            )
            if state.isEdited { P("User magic link edited successfully.") }
            context.build(
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
