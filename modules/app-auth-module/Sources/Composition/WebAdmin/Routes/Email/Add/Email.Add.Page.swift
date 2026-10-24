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

extension Email.Add {
    struct Page: WebComponents.Component {

        struct State {
            let form: Email.Form.Component.State
            let breadcrumb: [AdminBreadcrumb.Link]
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))

                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add user email",
                            description:
                                "Create an email address for a user identity."
                        )
                    )
                )
                context.build(
                    Email.Form.Component(
                        state: state.form,
                        action: "/admin/auth/emails/add/",
                        submitLabel: "Add email"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
