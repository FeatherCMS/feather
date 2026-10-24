import FeatherWebAdmin
import HTML
import Hummingbird
import UserModule
import WebBuilders
import WebComponents

extension Identity.Edit {
    struct Page: Component {
        let routes: Identity.Router.Routes
        let id: String
        let form: Identity.Edit.Form.Component.State
        let permissions: AdminListActions
        let nonceToken: String?

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit user identity",
                            description: "Update this user identity."
                        )
                    )
                )
                context.build(
                    Identity.Edit.Form.Component(
                        state: form,
                        action: routes.editPath(id)
                            .description,
                        submitLabel: "Save changes",
                        viewHref: routes.detailsPath(id)
                            .description,
                        removeHref: permissions.allows(
                            Identity.Permissions.delete
                        )
                            ? routes.removePath(id)
                            : nil,
                        nonceToken: nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
