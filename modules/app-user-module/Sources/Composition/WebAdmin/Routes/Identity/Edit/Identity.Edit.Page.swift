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
        let form: Form.Component.State
        let permissions: AdminListActions
        let nonceToken: String?

        func html(context: inout BuilderContext) -> Section {
            var actions = [
                AdminButton.State(
                    label: "View",
                    href: routes.detailsPath(id).description,
                    style: .secondary
                )
            ]
            if permissions.allows(Identity.Permissions.delete) {
                actions.append(
                    AdminButton.State(
                        label: "Remove",
                        href: routes.removePath(id),
                        style: .destructive
                    )
                )
            }

            return Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit user identity",
                            description: "Update this user identity.",
                            actions: actions
                        )
                    )
                )
                context.build(
                    Form.Component(
                        state: form,
                        action: routes.editPath(id)
                            .description,
                        submitLabel: "Save changes",
                        nonceToken: nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
