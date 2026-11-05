import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Search {
    struct Page: Component {
        struct State {
            let items: [Model.Item]
            let pageState: AdminListPageState
            let search: String
            let permissions: AdminListActions
            let isPicker: Bool
            let routes: ContactModule.Form.Router.Routes
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
                            description:
                                "Create and manage reusable contact forms."
                        )
                    )
                )
                context.build(
                    Page.Content(
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
}
