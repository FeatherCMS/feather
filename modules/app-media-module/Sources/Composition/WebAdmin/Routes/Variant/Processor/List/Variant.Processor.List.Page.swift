import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import SGML
import WebBuilders
import WebComponents

extension Variant.Processor.List {
    struct Page: Component {
        let variantId: String
        let processors:
            [MediaAdminAPI.Components.Schemas
                .MediaVariantProcessorQueryItemSchema]
        let pageState: AdminListPageState
        let search: String?
        let permissions: AdminListActions
        let routes: Variant.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Processors",
                            description:
                                "Manage the processors used by this media variant."
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
                            title: "Variant processors",
                            description:
                                "Manage the processing steps for this media variant."
                        )
                    ) {
                        context.build(
                            Page.Content(
                                variantId: variantId,
                                processors: processors,
                                pageState: pageState,
                                search: search,
                                permissions: permissions,
                                routes: routes,
                            )
                        )
                    }
                )
            }
            .class("cms-section")
        }
    }
}
