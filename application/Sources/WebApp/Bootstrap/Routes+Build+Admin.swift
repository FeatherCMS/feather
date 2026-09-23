import FeatherContracts
import WebApplication
import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import AccountFrontend
import SystemFrontend
import AuthFrontend
import FeatherAdmin
import FeatherApplication
import Hummingbird

func buildAdminRoutes(
    router: any RouterMethods<AuthenticatedRequestContext>,
    renderingEngine: any RenderingEngine,
    adminEvents: any EventPublisher,
    apiBuilder: APIBuilder
) {
    AuthFrontend.AdminAuth(
        apiBuilder: apiBuilder.auth,
        renderingEngine: renderingEngine
    )
    .route(on: router)
    AccountAdmin(apiBuilder: apiBuilder.account, renderingEngine: renderingEngine)
        .route(on: router)
    AdminUser(apiBuilder: apiBuilder.user, renderingEngine: renderingEngine)
        .route(on: router)
    AdminSystem(apiBuilder: apiBuilder.system, renderingEngine: renderingEngine, adminEvents: adminEvents)
        .route(on: router)
    AdminAnalytics(apiBuilder: apiBuilder.analytics, renderingEngine: renderingEngine)
        .route(on: router)
    AdminRedirect(apiBuilder: apiBuilder.redirect, renderingEngine: renderingEngine)
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
    AdminNewsletter(apiBuilder: apiBuilder.newsletter, renderingEngine: renderingEngine)
        .route(on: router)
    AdminContact(apiBuilder: apiBuilder.contact, renderingEngine: renderingEngine)
        .route(on: router)
}
