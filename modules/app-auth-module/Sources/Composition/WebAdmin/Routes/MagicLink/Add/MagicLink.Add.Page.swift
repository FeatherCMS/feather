import AuthAdminAPI
import AuthModule
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

extension MagicLink.Add {
    struct Page: Component {

        struct State {
            let form: Form.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: MagicLink.Router.Routes
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
                    Form(
                        state: state.form,
                        action: state.routes.add.path,
                        submitLabel: "Add magic link"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
