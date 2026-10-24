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

extension Credential.Edit {
    struct Page: WebComponents.Component {
        struct State {
            let id: String
            let form: Credential.Form.Component.State
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
                    Credential.Form.Component(
                        state: state.form,
                        action: "/admin/auth/credentials/\(state.id)/edit/",
                        submitLabel: "Edit credential",
                        removeHref:
                            "/admin/auth/credentials/\(state.id)/remove/"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
