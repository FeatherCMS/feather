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
import SystemWebAdmin
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AuthCredentialEdit: Component {
    struct State {
        let id: String
        let form: AuthCredentialForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit user credential",
                        description: "Update a user credential."
                    )
                )
            )
            context.build(
                AuthCredentialForm(
                    state: state.form,
                    action: "/admin/auth/credentials/\(state.id)/edit/",
                    submitLabel: "Edit credential",
                    removeHref: "/admin/auth/credentials/\(state.id)/remove/"
                )
            )
        }
        .class("cms-section")
    }
}
