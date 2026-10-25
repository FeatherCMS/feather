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

extension Credential.Add {
    struct Page: WebComponents.Component {
        struct State {
            let form: Credential.Form.Component.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Credential.Router.Routes
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
                    Credential.Form.Component(
                        state: state.form,
                        action: state.routes.add.path,
                        submitLabel: "Add credential",
                        removeHref: nil
                    )
                )
            }
            .class("cms-section")
        }
    }
}
