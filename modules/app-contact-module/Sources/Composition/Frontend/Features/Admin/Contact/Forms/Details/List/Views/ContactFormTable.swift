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
        let items: [AdminContactFormDetailsItem]
        let pageState: NewAdminListPageState
        let search: String
        let permissions: NewAdminListActions
        let isPicker: Bool
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: state.isPicker
                            ? "Select contact form" : "Contact forms",
                        description: "Create and manage reusable contact forms."
                    )
                )
            )
            context.build(
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
