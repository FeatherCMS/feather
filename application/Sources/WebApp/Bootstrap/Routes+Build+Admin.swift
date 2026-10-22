import SystemModule
import FeatherWebShared
import FeatherModuleKit
import WebApplication
import BlogWebAdmin
import MediaWebAdmin
import ContactWebAdmin
import NewsletterFrontend
import WebModuleWebAdmin
import WebModuleWebApp
import AnalyticsFrontend
import RedirectWebAdmin
import UserWebAdmin
import AccountWebAdmin
import SystemWebAdmin
import AuthWebAdmin
import FeatherWebAdmin
import FeatherApplication
import Hummingbird

func buildAdminRoutes(
    router: any RouterMethods<AuthenticatedRequestContext>,
    environment: AppEnvironment,
    renderingEngine: any RenderingEngine,
    adminEvents: any EventPublisher,
    apiBuilder: APIBuilder,
    systemRoutes: SystemWebAdmin.Router.Routes,
    redirectRoutes: RedirectWebAdmin.Router.Routes
) {
    AuthWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    AccountWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    UserWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    SystemWebAdmin.WebAdmin
        .Router(
            environment: environment,
            renderingEngine: renderingEngine,
            adminEvents: adminEvents,
            routes: systemRoutes
        )
        .route(on: router)
    AdminAnalytics(
        apiBuilder: apiBuilder.analytics,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    RedirectWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: redirectRoutes
    )
    .route(on: router)
    BlogWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents
    )
    .route(on: router)

    Router(
        apiBuilder: apiBuilder.web,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents
    )
    .route(on: router)
    MediaWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    AdminNewsletter(
        apiBuilder: apiBuilder.newsletter,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    AdminContact(
        apiBuilder: apiBuilder.contact,
        renderingEngine: renderingEngine
    )
    .route(on: router)
}
