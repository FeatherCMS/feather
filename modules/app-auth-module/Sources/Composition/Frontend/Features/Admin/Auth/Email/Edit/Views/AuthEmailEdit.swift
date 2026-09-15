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

struct AuthEmailEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: AuthEmailForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))

            context.build(
                NewAdminPageHeader(
                    state: .init(
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
