import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
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

extension Email.Edit {
    struct Page: WebComponents.Component {

        struct State {
            let id: String
            let isEdited: Bool
            let form: Email.Form.Component.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Email.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))

                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit user email",
                            description: "Update a user email address.",
                            actions: [
                                .init(
                                    label: "Remove email",
                                    href: state.routes.removePath(state.id),
                                    style: .destructive
                                )
                            ]
                        )
                    )
                )
                if state.isEdited { P("User email edited successfully.") }
                context.build(
                    Email.Form.Component(
                        state: state.form,
                        action: state.routes.editPath(state.id),
                        submitLabel: "Edit email",
                        removeHref: nil
                    )
                )
            }
            .class("cms-section")
        }
    }
}
