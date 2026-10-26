public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
import NewsletterApplication
import NewsletterModule

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let root: WebRoute
        let campaign: Campaign.Router.Routes
        let subscriber: Subscriber.Router.Routes
        let overview: Overview.Router.Routes

        public init(admin: WebRoute, root: WebRoute) {
            let campaign = Campaign.Router.Routes(admin: admin, root: root)
            let subscriber = Subscriber.Router.Routes(
                admin: admin,
                root: root,
                campaigns: campaign
            )
            self.admin = admin
            self.root = root
            self.campaign = campaign
            self.subscriber = subscriber
            self.overview = .init(admin: admin, root: root)
        }

        public static let standard = Routes(
            admin: WebRoute.root.appending(pathComponent: "admin"),
            root: WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "newsletter")
        )
    }

    private let environment: AppEnvironment
    public let renderingEngine: any RenderingEngine
    private let routes: Routes

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Routes = .standard
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
        self.routes = routes
    }

    public func route(on router: any RouterMethods<AuthenticatedRequestContext>)
    {
        Overview.Router(
            renderingEngine: renderingEngine,
            routes: routes.overview
        )
        .route(on: router)

        Campaign.Search
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Campaign.Detail
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Campaign.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Campaign.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)

        Campaign.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)

        Issue.Search
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Issue.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Issue.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Issue.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Issue.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Issue.TestEmail
            .Router(environment: environment, routes: routes.campaign)
            .route(on: router)

        Campaign.Subscriber.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Campaign.Subscriber.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Campaign.Subscriber.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Campaign.Subscriber.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.campaign
            )
            .route(on: router)
        Campaign.Subscriber.Remove
            .Router(
                environment: environment,
                routes: routes.campaign
            )
            .route(on: router)
        Subscriber.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.subscriber
            )
            .route(on: router)
        Subscriber.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.subscriber
            )
            .route(on: router)
        Subscriber.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.subscriber
            )
            .route(on: router)
        Subscriber.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.subscriber
            )
            .route(on: router)
    }
}
