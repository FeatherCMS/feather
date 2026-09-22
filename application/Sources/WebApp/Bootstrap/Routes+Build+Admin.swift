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
    router: Router<DefaultRequestContext>,
    renderingEngine: any RenderingEngine,
    adminEvents: any EventPublisher
) {
    AuthFrontend.AdminAuth(
        renderingEngine: renderingEngine
    )
    .route(on: router)
    AccountAdmin(renderingEngine: renderingEngine)
        .route(on: router)
    AdminUser(renderingEngine: renderingEngine)
        .route(on: router)
    AdminSystem(renderingEngine: renderingEngine, adminEvents: adminEvents)
        .route(on: router)
    AdminAnalytics(renderingEngine: renderingEngine)
        .route(on: router)
    AdminRedirect(renderingEngine: renderingEngine)
        .route(on: router)
    AdminBlog(
        renderingEngine: renderingEngine,
        adminEvents: adminEvents
    )
    .route(on: router)

    AdminWeb(
        renderingEngine: renderingEngine,
        adminEvents: adminEvents
    )
    .route(on: router)
    AdminMedia(renderingEngine: renderingEngine)
        .route(on: router)
    AdminNewsletter(renderingEngine: renderingEngine)
        .route(on: router)
    AdminContact(renderingEngine: renderingEngine)
        .route(on: router)
}
