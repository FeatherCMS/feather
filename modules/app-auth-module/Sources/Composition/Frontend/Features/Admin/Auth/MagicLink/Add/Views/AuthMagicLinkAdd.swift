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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))

            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add user magic link",
                        description: "Create a sign-in magic link."
                    )
                )
            )
            context.build(
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
