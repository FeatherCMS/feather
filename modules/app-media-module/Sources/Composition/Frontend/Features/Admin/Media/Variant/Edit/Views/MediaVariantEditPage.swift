import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import SGML
import WebBuilders
import WebComponents

struct MediaVariantEditPage: Component {
    let id: String
    let detail: MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    let form: MediaVariantFormView

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: MediaVariantRoutes.breadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit \(detail.name)",
                        description: "Update the media variant details."
                    )
                )
            )
            context.build(AdminMediaVariantTabs(id: id, active: .details))
            context.build(form)
        }
        .class("cms-section")
    }
}
