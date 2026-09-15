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

struct AuthEmailAdd: Component {

    struct State {
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
                        title: "Add user email",
                        description:
                            "Create an email address for a user identity."
                    )
                )
            )
            context.build(
                AuthEmailForm(
                    state: state.form,
                    action: "/admin/auth/emails/add/",
                    submitLabel: "Add email"
                )
            )
        }
        .class("cms-section")
    }
}
