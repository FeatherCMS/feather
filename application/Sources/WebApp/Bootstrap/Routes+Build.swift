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

func buildRouter(
    environment: AppEnvironment,
    templateOptions: [WebPageTemplateOption],
    templateDefinitions: [WebTemplateDefinition],
    templatePaths: [URL]
) async throws -> Router<DefaultRequestContext> {

    let router = Router(context: DefaultRequestContext.self)
    let apiBuilder = APIBuilder(apiBaseURL: environment.apiBaseURL)
    let mediaResolver = MediaResolver(
        mediaBaseURL: environment.publicOrigins.mediaBaseURL
    )

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

    var adminEvents = EventRegistry()
    WebFrontend.WebEventHandlers.register(in: &adminEvents)
    BlogFrontend.BlogEventHandlers.register(in: &adminEvents)
    NewsFrontend.NewsEventHandlers.register(in: &adminEvents)
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
    let renderingEngine = DefaultRenderingEngine(
        publicOrigins: environment.publicOrigins,
        adminEvents: adminEvents,
        adminPageRenderContextProvider: DefaultAdminPageRenderContextProvider(
            events: adminEvents,
            accountAPIBuilder: .init(apiBaseURL: environment.apiBaseURL),
            mediaAPIBuilder: .init(apiBaseURL: environment.apiBaseURL),
            mediaResolver: mediaResolver
        )
    )
    let applicationTemplatePaths = Bundle.module.url(
        forResource: "Templates",
        withExtension: nil
    )
    var resolvedTemplatePaths =
        templatePaths + (applicationTemplatePaths.map { [$0] } ?? [])
    #if DEBUG
    let applicationSourceTemplatePath = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Resources/Templates", isDirectory: true)
    resolvedTemplatePaths.append(applicationSourceTemplatePath)
    #endif
    let themeRenderer = try DefaultThemeRenderer(
        templateLoader: DefaultTemplateLoader(
            paths: resolvedTemplatePaths
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
        middleware: DefaultAuthMiddleware(
            apiBaseURL: environment.apiBaseURL,
            secureCookies: environment.publicOrigins.usesSecureCookies
        )
    )
    buildAppRoutes(
        router: router,
        authRouter: authRouter,
        renderingEngine: renderingEngine,
        themeRenderer: themeRenderer,
        publicContentEvents: publicContentEvents,
        apiBuilder: apiBuilder,
        mediaResolver: mediaResolver,
        publicOrigins: environment.publicOrigins
    )

    AuthFrontendRoutes.registerAppRoutes(
        router: router,
        renderingEngine: renderingEngine,
        authAPIBuilder: apiBuilder.auth,
        usesSecureCookies: environment.publicOrigins.usesSecureCookies
    )

    // MARK: - admin

    let adminRouter =
        authRouter
        .add(
            middleware: AdminAuthMiddleware(
                loginPath: "/login/",
                unauthorizedPath: "/"
            )
        )
        .group(context: AuthenticatedRequestContext.self)
    buildAdminRoutes(
        router: adminRouter,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents,
        apiBuilder: apiBuilder
    )

    return router
}
