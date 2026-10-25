import FeatherWebAdmin
import HTML
import Hummingbird
import UserModule
import WebBuilders
import WebComponents

extension Role.Edit {
    struct Page: Component {
        let routes: Role.Router.Routes
        let id: String
        let form: Form.Component.State
        let permissions: AdminListActions
        let nonceToken: String?

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(AdminBreadcrumb(links: routes.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit user role",
                            description: "Update this user role.",
                            actions: permissions.allows(Role.Permissions.delete)
                                ? [
                                    .init(
                                        label: "Remove",
                                        href: routes.removePath(id),
                                        style: .destructive
                                    )
                                ]
                                : []
                        )
                    )
                )
                context.build(
                    Form.Component(
                        state: form,
                        action: routes.editPath(id),
                        submitLabel: "Save changes",
                        viewHref: routes.detailsPath(id)
                            .description,
                        removeHref: nil,
                        nonceToken: nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
