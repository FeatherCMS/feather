import SystemModule
import FeatherWebShared
import FeatherModuleKit
import WebApplication
import BlogWebAdmin
import MediaWebAdmin
import ContactWebAdmin
import NewsletterWebAdmin
import NewsWebAdmin
import WebModuleWebAdmin
import WebModuleWebApp
import AnalyticsWebAdmin
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
    redirectRoutes: RedirectWebAdmin.Router.Routes,
    newsRoutes: NewsWebAdmin.Router.Routes
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
    SystemWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents,
        routes: systemRoutes
    )
    .route(on: router)
    AnalyticsWebAdmin.Router(
        apiBuilder: apiBuilder.analyticsAdmin,
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

    WebModuleWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents
    )
    .route(on: router)
    MediaWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    NewsletterWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    NewsWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: newsRoutes
    )
    .route(on: router)
    ContactWebAdmin.Router(
        apiBuilder: apiBuilder.contact,
        renderingEngine: renderingEngine
    )
    .route(on: router)
}
