import FeatherWebAdmin
import HTML
import MediaModule
import SGML
import WebBuilders
import WebComponents

extension Variant.Add {
    struct Page: Component {
        let form: Variant.Form
        let routes: Variant.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add media variant",
                            description:
                                "Create a reusable media output variant."
                        )
                    )
                )
                context.build(form)
            }
            .class("cms-section")
        }
    }
}
