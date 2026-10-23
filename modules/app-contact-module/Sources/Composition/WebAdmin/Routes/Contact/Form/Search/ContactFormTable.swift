import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormTable: Component {
    struct State {
        let items: [ContactModule.Form.Search.Model.Item]
        let pageState: AdminListPageState
        let search: String
        let permissions: AdminListActions
        let isPicker: Bool
        let routes: Contact.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: state.routes.formsBreadcrumb)
            )
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
                    isPicker: state.isPicker,
                    routes: state.routes
                )
            )
        }
        .class("cms-section")
    }
}
