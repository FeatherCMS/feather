import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct MediaVariantAddPage: Component {
    let form: MediaVariantFormView

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: MediaVariantRoutes.breadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add media variant",
                        description: "Create a reusable media output variant."
                    )
                )
            )
            context.build(form)
        }
        .class("cms-section")
    }
}
