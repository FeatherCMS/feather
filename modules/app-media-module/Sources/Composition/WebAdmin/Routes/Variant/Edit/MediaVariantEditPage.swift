import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import SGML
import WebBuilders
import WebComponents

struct MediaVariantEditPage: Component {
    let id: String
    let detail: MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    let form: MediaVariantFormView
    let routes: Variant.Router.Routes

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: routes.breadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit \(detail.name)",
                        description: "Update the media variant details."
                    )
                )
            )
            context.build(
                Variant.Tabs(id: id, active: .details, routes: routes)
            )
            context.build(form)
        }
        .class("cms-section")
    }
}
