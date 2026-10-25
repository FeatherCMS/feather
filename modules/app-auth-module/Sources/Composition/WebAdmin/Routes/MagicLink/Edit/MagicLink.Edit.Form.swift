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

extension MagicLink.Edit {
    enum Form {}
}

extension MagicLink.Edit.Form {
    struct Component: WebComponents.Component {

        struct State {
            let id: String
            let isEdited: Bool
            let form: MagicLink.Add.Form.State
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
                            title: "Edit user magic link",
                            description: "Update a sign-in magic link."
                        )
                    )
                )
                if state.isEdited { P("User magic link edited successfully.") }
                context.build(
                    MagicLink.Add.Form(
                        state: state.form,
                        action: state.routes.editPath(state.id),
                        submitLabel: "Edit magic link",
                        removeHref: state.routes.removePath(state.id),
                        removeLabel: "Remove magic link"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
