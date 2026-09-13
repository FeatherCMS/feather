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

struct AuthCredentialAdd: Component {
    struct State {
        let form: AuthCredentialForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add user credential",
                        description: "Create a credential for a user."
                    )
                )
            )
            context.render(
                AuthCredentialForm(
                    state: state.form,
                    action: "/admin/auth/credentials/add/",
                    submitLabel: "Add credential",
                    removeHref: nil
                )
            )
        }
        .class("cms-section")
    }
}
