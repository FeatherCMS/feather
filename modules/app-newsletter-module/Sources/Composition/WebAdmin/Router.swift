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
            root: newsletterRoute
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
        AdminEditNewsletterCampaign(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: campaignRoutes
        )
        .controller.route(on: router)
        AdminRemoveNewsletterCampaign(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddNewsletterCampaign(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

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

        AdminViewNewsletterCampaignSubscriber(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminListNewsletterCampaignSubscribers(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminAddNewsletterCampaignSubscriber(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditNewsletterCampaignSubscriber(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveNewsletterCampaignSubscriber(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
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
