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

struct AuthMagicLinkAdd: Component {

    struct State {
        let form: AuthMagicLinkForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))

            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add user magic link",
                        description: "Create a sign-in magic link."
                    )
                )
            )
            context.render(
                AuthMagicLinkForm(
                    state: state.form,
                    action: "/admin/auth/magic-links/add/",
                    submitLabel: "Add magic link"
                )
            )
        }
        .class("cms-section")
    }
}
