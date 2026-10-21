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

struct AuthCredentialAdd: Component {
    struct State {
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
                        title: "Add user credential",
                        description: "Create a credential for a user."
                    )
                )
            )
            context.build(
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
