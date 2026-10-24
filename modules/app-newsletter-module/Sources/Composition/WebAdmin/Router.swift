public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
import NewsletterApplication
import NewsletterModule

public struct Router {
    private let environment: AppEnvironment
    public let renderingEngine: any RenderingEngine

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
    }

    public func route(on router: any RouterMethods<AuthenticatedRequestContext>)
    {
        let adminRoute = WebRoute.root.appending(pathComponent: "admin")
        let newsletterRoute = adminRoute.appending(pathComponent: "newsletter")
        let campaignRoutes = Campaign.Router.Routes(
            admin: adminRoute,
            root: newsletterRoute
        )
        let subscriberRoutes = Subscriber.Router.Routes(
            admin: adminRoute,
            root: newsletterRoute,
            campaigns: campaignRoutes
        )
        Overview.Router(
            renderingEngine: renderingEngine,
            routes: .init(admin: adminRoute, root: newsletterRoute)
        )
        .route(on: router)

        Campaign.Search
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Campaign.Detail
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Campaign.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Campaign.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)

        Campaign.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)

        Issue.Search
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Issue.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Issue.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Issue.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Issue.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Issue.TestEmail.Router(environment: environment, routes: campaignRoutes)
            .route(on: router)

        Campaign.Subscriber.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Campaign.Subscriber.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Campaign.Subscriber.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Campaign.Subscriber.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: campaignRoutes
            )
            .route(on: router)
        Campaign.Subscriber.Remove
            .Router(
                environment: environment,
                routes: campaignRoutes
            )
            .route(on: router)
        Subscriber.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: subscriberRoutes
            )
            .route(on: router)
        Subscriber.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: subscriberRoutes
            )
            .route(on: router)
        Subscriber.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: subscriberRoutes
            )
            .route(on: router)
    }
}
