import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
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

struct AuthEmailEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AuthEmailForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))

            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit user email",
                        description: "Update a user email address."
                    )
                )
            )
            if state.isEdited { P("User email edited successfully.") }
            context.build(
                AuthEmailForm(
                    state: state.form,
                    action: "/admin/auth/emails/\(state.id)/edit/",
                    submitLabel: "Edit email",
                    removeHref: "/admin/auth/emails/\(state.id)/remove/",
                    removeLabel: "Remove email"
                )
            )
        }
        .class("cms-section")
    }
}
