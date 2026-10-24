import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import WebComponents

extension Campaign {
    struct Tabs: Component {
        enum Tab: Equatable {
            case details
            case subscribers
            case issues
        }

        let id: String
        let active: Tab
        let routes: Campaign.Router.Routes

        init(
            id: String,
            active: Tab,
            routes: Campaign.Router.Routes = .standard
        ) {
            self.id = id
            self.active = active
            self.routes = routes
        }

        var links: [AdminTabBar.Link] {
            [
                .init(
                    label: "Details",
                    href:
                        routes.detailsPath(id),
                    isCurrent: active == .details
                ),
                .init(
                    label: "Subscribers",
                    href:
                        routes.subscribers.path(
                            parameter: "newsletterId",
                            value: id
                        ),
                    isCurrent: active == .subscribers
                ),
                .init(
                    label: "Issues",
                    href:
                        routes.issuesPath(newsletterId: id),
                    isCurrent: active == .issues
                ),
            ]
        }

        func html(context: inout BuilderContext) -> Div {
            context.build(AdminTabBar(links: links))
        }
    }
}
