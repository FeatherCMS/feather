import FeatherWebAdmin
import HTML
import Hummingbird
import MediaModule
import SGML
import WebBuilders
import WebComponents

extension Variant.Processor {
    enum Add {
        struct Page: Component {
            let variantId: String
            let form: Form
            let routes: Variant.Router.Routes

            func html(context: inout BuilderContext) -> some BasicTag {
                Section {
                    context.build(
                        AdminBreadcrumb(links: routes.breadcrumb)
                    )
                    context.build(
                        AdminPageHeader(
                            state: .primary(
                                title: "Add processor",
                                description:
                                    "Configure a processor for this media variant."
                            )
                        )
                    )
                    context.build(
                        Variant.Tabs(
                            id: variantId,
                            active: .processors,
                            routes: routes
                        )
                    )
                    context.build(
                        AdminRelationshipGroup(
                            pageHeader: .secondary(
                                title: "Processor configuration",
                                description:
                                    "Configure how this variant is processed."
                            )
                        ) {
                            context.build(form)
                        }
                    )
                }
                .class("cms-section")
            }
        }
    }
}
