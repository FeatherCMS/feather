import FeatherAdmin
import HTML
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebContracts

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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Metadata",
                        description:
                            "Manage search and sharing metadata for web pages."
                    )
                )
            )
            context.build(
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
