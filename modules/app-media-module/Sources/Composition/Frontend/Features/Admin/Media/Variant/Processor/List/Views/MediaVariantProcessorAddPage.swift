import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct MediaVariantProcessorAddPage: Component {
    let variantId: String
    let form: MediaVariantProcessorFormView

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: MediaVariantRoutes.breadcrumb))
            context.build(NewAdminPageHeader(state: .init(
                title: "Add processor",
                description: "Configure a processor for this media variant."
            )))
            context.build(AdminMediaVariantTabs(id: variantId, active: .processors))
            context.build(form)
        }
        .class("cms-section")
    }
}
