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
    systemRoutes: SystemWebAdmin.Router.Routes,
    redirectRoutes: RedirectWebAdmin.Router.Routes,
    newsRoutes: NewsWebAdmin.Router.Routes,
    blogRoutes: BlogWebAdmin.Router.Routes,
    contactRoutes: Contact.Router.Routes,
    newsletterRoutes: NewsletterWebAdmin.Router.Routes,
    authRoutes: AuthWebAdmin.Router.Routes,
    userRoutes: UserWebAdmin.Router.Routes,
    mediaRoutes: MediaWebAdmin.Router.Routes,
    accountRoutes: AccountWebAdmin.Router.Routes,
    webAdminRoutes: WebModuleWebAdmin.Router.Routes
) {
    AuthWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: authRoutes
    )
    .route(on: router)
    AccountWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: accountRoutes
    )
    .route(on: router)
    UserWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: userRoutes
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
        environment: environment,
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
        adminEvents: adminEvents,
        routes: blogRoutes
    )
    .route(on: router)

    WebModuleWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents,
        routes: webAdminRoutes
    )
    .route(on: router)
    MediaWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: mediaRoutes
    )
    .route(on: router)
    NewsletterWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: newsletterRoutes
    )
    .route(on: router)
    NewsWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: newsRoutes
    )
    .route(on: router)
    ContactWebAdmin.Router(
        environment: environment,
        renderingEngine: renderingEngine,
        routes: contactRoutes
    )
    .route(on: router)
}
