import FeatherWebAdmin
import HTML
import Hummingbird
import UserModule
import WebBuilders
import WebComponents

extension Role.Add {
    struct Page: Component {
        let routes: Role.Router.Routes
        let form: Role.Add.FormComponent.State
        let nonceToken: String?

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(AdminBreadcrumb(links: routes.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add user role",
                            description: "Create a user role."
                        )
                    )
                )
                context.build(
                    Role.Add.FormComponent(
                        state: form,
                        action: routes.add.path,
                        submitLabel: "Add role",
                        viewHref: nil,
                        removeHref: nil,
                        nonceToken: nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
