import FeatherWebAdmin
import HTML
import Hummingbird
import MediaModule
import SGML
import WebBuilders
import WebComponents

struct MediaVariantProcessorAddPage: Component {
    let variantId: String
    let form: MediaVariantProcessorFormView
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
            context.build(form)
        }
        .class("cms-section")
    }
}
