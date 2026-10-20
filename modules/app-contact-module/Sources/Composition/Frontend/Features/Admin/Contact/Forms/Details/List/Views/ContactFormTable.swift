import ContactContracts
import FeatherWebAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormTable: Component {
    struct State {
        let items: [AdminContactFormDetailsItem]
        let pageState: AdminListPageState
        let search: String
        let permissions: AdminListActions
        let isPicker: Bool
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
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
