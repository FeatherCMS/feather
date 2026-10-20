import FeatherWebAdmin
import HTML
import Hummingbird
import UserModule
import WebBuilders
import WebComponents

extension Identity.Add {
    struct Page: Component {
        let routes: Identity.Router.Routes
        let form: Identity.Add.FormComponent.State
        let nonceToken: String?

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add user identity",
                            description: "Create a user identity."
                        )
                    )
                )
                context.build(
                    Identity.Add.FormComponent(
                        state: form,
                        action: routes.add.path,
                        submitLabel: "Add identity",
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
