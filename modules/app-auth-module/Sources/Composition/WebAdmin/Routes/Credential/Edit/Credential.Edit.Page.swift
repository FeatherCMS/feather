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
            let routes: Credential.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit user credential",
                            description: "Update a user credential.",
                            moreActions: [
                                .init(
                                    label: "Remove",
                                    href: state.routes.removePath(state.id),
                                    style: .destructive
                                )
                            ]
                        )
                    )
                )
                context.build(
                    Credential.Form.Component(
                        state: state.form,
                        action: state.routes.editPath(state.id),
                        submitLabel: "Edit credential",
                    )
                )
            }
            .class("cms-section")
        }
    }
}
