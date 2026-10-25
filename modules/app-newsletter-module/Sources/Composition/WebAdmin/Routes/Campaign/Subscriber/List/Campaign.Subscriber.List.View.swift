import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Campaign.Subscriber.List {
    struct View: Component {
        struct State {
            let newsletterId: String
            let items: [Item]
            let pageState: AdminListPageState
            let search: String?
            let permissions: AdminListActions
            let routes: Campaign.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(links: state.routes.campaignBreadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit newsletter campaign",
                            description:
                                "Update the newsletter campaign settings."
                        )
                    )
                )
                context.build(
                    Campaign.Tabs(
                        id: state.newsletterId,
                        active: .subscribers,
                        routes: state.routes
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Subscribers",
                            description:
                                "Manage the subscribers linked to this campaign."
                        )
                    ) {
                        context.build(
                            Content(
                                newsletterId: state.newsletterId,
                                items: state.items,
                                pageState: state.pageState,
                                search: state.search,
                                permissions: state.permissions,
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
