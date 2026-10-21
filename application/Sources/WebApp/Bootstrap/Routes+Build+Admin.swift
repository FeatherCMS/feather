import SystemModule
import FeatherWebShared
import FeatherModuleKit
import WebApplication
import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectWebAdmin
import UserWebAdmin
import AccountFrontend
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
    AccountAdmin(
        apiBuilder: apiBuilder.account,
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
    AdminBlog(
        apiBuilder: apiBuilder.blog,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents
    )
    .route(on: router)

    AdminWeb(
        apiBuilder: apiBuilder.web,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents
    )
    .route(on: router)
    AdminMedia(apiBuilder: apiBuilder.media, renderingEngine: renderingEngine)
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
