import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Issue.Search {
    struct Table: Component {
        struct State {
            let newsletterId: String
            let items: [Item]
            let pageState: AdminListPageState
            let permissions: AdminListActions
            let search: String?
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
                            ),
                            .init(
                                label: "Issues",
                                link: state.routes.issuesPath(
                                    newsletterId: state.newsletterId
                                )
                            ),
                        ]
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Campaign issues",
                            description:
                                "Manage issues for this newsletter campaign."
                        )
                    )
                )
                context.build(
                    Campaign.Tabs(id: state.newsletterId, active: .issues)
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Issues",
                            description:
                                "Manage the issues scheduled for this campaign."
                        )
                    ) {
                        context.build(
                            Content(
                                newsletterId: state.newsletterId,
                                items: state.items,
                                pageState: state.pageState,
                                permissions: state.permissions,
                                search: state.search,
                                routes: state.routes
                            )
                        )
                    }
                )
            }
            .class("cms-section")
        }
    }
}
