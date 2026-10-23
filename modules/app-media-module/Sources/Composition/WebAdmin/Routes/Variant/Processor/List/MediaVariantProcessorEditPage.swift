import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import SGML
import WebBuilders
import WebComponents

struct MediaVariantProcessorEditPage: Component {
    let variantId: String
    let processor:
        MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema
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
                        title: "Edit \(processor.name)",
                        description:
                            "Update the processor used by this media variant."
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
