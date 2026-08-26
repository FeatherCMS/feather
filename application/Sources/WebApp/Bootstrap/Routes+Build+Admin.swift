import FeatherContracts
import WebApplication
import WebContracts
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
import WebApplication

func buildAdminRoutes(
    router: Router<DefaultRequestContext>,
    renderingEngine: any RenderingEngine,
    referenceTypeOptions: [WebMetadataReferenceTypeOption],
    templateOptions: [WebPageTemplateOption],
    adminEvents: any EventPublisher
) {
    AuthFrontendRoutes.registerAdminRoutes(
        router: router,
        renderingEngine: renderingEngine
    )
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
        templateOptions: templateOptions
    )
    .route(on: router)

    AdminWeb(
        renderingEngine: renderingEngine,
        referenceTypeOptions: referenceTypeOptions,
        templateOptions: templateOptions
    )
    .route(on: router)
    AdminMedia(renderingEngine: renderingEngine)
        .route(on: router)
    AdminNewsletter(renderingEngine: renderingEngine)
        .route(on: router)
    AdminContact(renderingEngine: renderingEngine)
        .route(on: router)
}
