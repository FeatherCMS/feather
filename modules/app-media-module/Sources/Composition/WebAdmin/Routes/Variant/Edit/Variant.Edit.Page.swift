import FeatherWebAdmin
import HTML
import Hummingbird
import MediaModule
import SGML
import WebBuilders
import WebComponents

extension Variant.Edit {
    struct Page: Component {
        let id: String
        let detail: Model
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
                            title: "Edit \(detail.name)",
                            description: "Update the media variant details.",
                            actions: form.removeHref.map {
                                [
                                    .init(
                                        label: "Remove",
                                        href: $0,
                                        style: .destructive
                                    )
                                ]
                            } ?? []
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
}
