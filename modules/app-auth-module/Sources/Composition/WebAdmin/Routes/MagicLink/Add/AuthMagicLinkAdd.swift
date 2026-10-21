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

struct AuthMagicLinkAdd: Component {

    struct State {
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
