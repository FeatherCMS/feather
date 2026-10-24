import FeatherWebAdmin
import FeatherWebShared
import HTML
import NewsletterModule
import NewsletterApplication
import SGML
import WebBuilders
import WebComponents

extension Campaign.Search {
    struct Table: Component {
        struct State {
            let items: [Campaign.Item]
            let pageState: AdminListPageState
            let search: String?
            let actions: AdminListActions
            let isPicker: Bool
            let routes: Campaign.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(
                        links: state.routes.breadcrumb + [
                            .init(
                                label: "Campaigns",
                                link: state.routes.list.path
                            )
                        ]
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: state.isPicker
                                ? "Select newsletter campaign" : "Campaigns",
                            description: state.isPicker
                                ? "Choose a campaign to insert."
                                : "Manage newsletter campaigns."
                        )
                    )
                )
                context.build(
                    Content(
                        items: state.items,
                        pageState: state.pageState,
                        search: state.search,
                        actions: state.actions,
                        isPicker: state.isPicker,
                        routes: state.routes
                    )
                )
            }
            .class("cms-section")
        }
    }
}
