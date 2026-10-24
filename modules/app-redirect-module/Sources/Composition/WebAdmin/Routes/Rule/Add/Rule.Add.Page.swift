import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import RedirectApplication
import RedirectModule
import WebBuilders
import WebComponents

extension Rule.Add {
    struct Page: Component {
        let form: Form.State
        let nonceToken: String
        let routes: Rule.Router.Routes

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add redirect rule",
                            description:
                                "Create a redirect from one path to another."
                        )
                    )
                )
                context.build(
                    Form(
                        state: form,
                        action: routes.add.path,
                        nonceToken: nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
