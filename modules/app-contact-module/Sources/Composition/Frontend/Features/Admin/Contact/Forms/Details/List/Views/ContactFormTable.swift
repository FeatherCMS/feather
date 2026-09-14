import ContactContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let items: [AdminContactFormDetailsItem]
        let pageState: NewAdminListPageState
        let search: String
        let permissions: NewAdminListActions
        let isPicker: Bool
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: state.isPicker
                            ? "Select contact form" : "Contact forms",
                        description: "Create and manage reusable contact forms."
                    )
                )
            )
            context.render(
                ContactFormTableContent(
                    items: state.items,
                    pageState: state.pageState,
                    search: state.search,
                    permissions: state.permissions,
                    isPicker: state.isPicker
                )
            )
        }
        .class("cms-section")
    }
}
