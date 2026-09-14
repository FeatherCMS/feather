import FeatherAdmin
import HTML
import SGML
import WebAdminAPI
import WebBuilders
import WebContracts
import WebComponents

struct WebMetadataTable: Component {
    struct State {
        let permissions: NewAdminListActions
        let metadata: [Components.Schemas.WebMetadataListItemSchema]
        let pageState: NewAdminListPageState
        let search: String?
        let referenceType: String?
        let referenceTypeOptions: [WebMetadataReferenceTypeOption]
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Metadata",
                        description: "Manage search and sharing metadata for web pages."
                    )
                )
            )
            context.render(
                WebMetadataTableContent(
                    metadata: state.metadata,
                    permissions: state.permissions,
                    pageState: state.pageState,
                    search: state.search,
                    referenceType: state.referenceType,
                    referenceTypeOptions: state.referenceTypeOptions
                )
            )
        }
        .class("cms-section")
    }
}
