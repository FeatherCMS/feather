import Foundation
import FeatherContracts
import WebApplication
import BlogFrontend
import NewsFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import WebContracts
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
import Hummingbird
import HummingbirdAuth
import AuthFrontend
import AccountFrontend
import Logging
import WebStandards
import WebApplication

func buildRouter(
    styleshetCollector: GlobalStylesheetCollector,
    environment: AppEnvironment,
    referenceTypeOptions: [WebMetadataReferenceTypeOption],
    templateOptions: [WebPageTemplateOption],
    templateDefinitions: [WebTemplateDefinition],
    templatePaths: [URL]
) async throws -> Router<DefaultRequestContext> {

    let router = Router(context: DefaultRequestContext.self)

    router.addMiddleware {
        LogRequestsMiddleware(Logger.current.logLevel)
        WebAppAnalyticsLogMiddleware(apiBaseURL: environment.apiBaseURL)
        HTTPErrorMiddleware<DefaultRequestContext>()
        RedirectRuleMiddleware(
            apiBaseURL: environment.apiBaseURL,
            siteBaseURL: environment.publicOrigins.siteBaseURL
        )
    }

    router.get("/health") { _, _ in
        Response(status: .ok)
    }

    let authAppClient = AuthAppAPIClient(
        apiBaseURL: environment.apiBaseURL
    )
    let publicContentRepository = WebPublicContentRepository(
        apiBaseURL: environment.apiBaseURL
    )
    var adminEvents = EventRegistry()
    BlogAdminDashboardEventHandlers.register(in: &adminEvents)
    WebAdminDashboardEventHandlers.register(in: &adminEvents)
    RedirectAdminDashboardEventHandlers.register(in: &adminEvents)
    AnalyticsAdminDashboardEventHandlers.register(in: &adminEvents)
    AdminMenuEventHandlers.register(in: &adminEvents)
    AccountAdminMenuEventHandlers.register(in: &adminEvents)
    AuthAdminMenuEventHandlers.register(in: &adminEvents)
    UserAdminMenuEventHandlers.register(in: &adminEvents)
    MediaAdminMenuEventHandlers.register(in: &adminEvents)
    RedirectAdminMenuEventHandlers.register(in: &adminEvents)
    AnalyticsAdminMenuEventHandlers.register(in: &adminEvents)
    BlogAdminMenuEventHandlers.register(in: &adminEvents)
    NewsAdminMenuEventHandlers.register(in: &adminEvents)
    NewsletterAdminMenuEventHandlers.register(in: &adminEvents)
    ContactAdminMenuEventHandlers.register(in: &adminEvents)
    WebAdminMenuEventHandlers.register(in: &adminEvents)
    let adminMenuCatalog = try await AdminMenuCatalog.load(from: adminEvents)
    let renderingEngine = DefaultRenderingEngine(
        publicOrigins: environment.publicOrigins,
        adminMenuCatalog: adminMenuCatalog
    )
    let applicationTemplatePaths = Bundle.module.url(
        forResource: "Templates",
        withExtension: nil
    )
    let themeRenderer = try DefaultThemeRenderer(
        templateLoader: DefaultTemplateLoader(
            paths: templatePaths + (applicationTemplatePaths.map { [$0] } ?? [])
        ),
        templatePath: { identifier in
            templateDefinitions.first { $0.id == identifier }?.path
        }
    )
    var publicContentEvents = EventRegistry()
    WebPublicContentEventHandlers.register(in: &publicContentEvents)
    WebMarkdownEventHandlers.register(in: &publicContentEvents)
    BlogWebPublicContentEventHandlers.register(in: &publicContentEvents)
    NewsWebPublicContentEventHandlers.register(in: &publicContentEvents)

    ContactMarkdownEventHandlers.register(
        in: &publicContentEvents,
        api: ContactAppAPIClient(apiBaseURL: environment.apiBaseURL)
    )
    NewsletterMarkdownEventHandlers.register(in: &publicContentEvents)

    let authRouter = router.add(
        middleware: DefaultAuthMiddleware<DefaultRequestContext>(
            apiBaseURL: environment.apiBaseURL,
            secureCookies: environment.publicOrigins.usesSecureCookies
        )
    )
    buildAppRoutes(
        router: router,
        authRouter: authRouter,
        renderingEngine: renderingEngine,
        themeRenderer: themeRenderer,
        publicContentRepository: publicContentRepository,
        publicContentEvents: publicContentEvents,
        styleshetCollector: styleshetCollector
    )

    AuthFrontendRoutes.registerAppRoutes(
        router: router,
        renderingEngine: renderingEngine,
        authAppClient: authAppClient
    )

    // MARK: - admin

    let adminRouter = authRouter.add(
        middleware: AdminAuthMiddleware<DefaultRequestContext>(
            loginPath: "/login/",
            unauthorizedPath: "/"
        )
    )
    buildAdminRoutes(
        router: adminRouter,
        renderingEngine: renderingEngine,
        referenceTypeOptions: referenceTypeOptions,
        templateOptions: templateOptions,
        adminEvents: adminEvents
    )

    return router
}
