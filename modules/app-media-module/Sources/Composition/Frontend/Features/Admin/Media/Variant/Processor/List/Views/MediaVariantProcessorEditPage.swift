import FeatherAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import SGML
import WebBuilders
import WebComponents

struct MediaVariantProcessorEditPage: Component {
    let variantId: String
    let processor: MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema
    let form: MediaVariantProcessorFormView

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: MediaVariantRoutes.breadcrumb))
            context.build(NewAdminPageHeader(state: .init(
                title: "Edit \(processor.name)",
                description: "Update the processor used by this media variant."
            )))
            context.build(AdminMediaVariantTabs(id: variantId, active: .processors))
            context.build(form)
        }
        .class("cms-section")
    }
}
