import SystemModule
import FeatherWebShared
import Foundation
import FeatherModuleKit
import WebApplication
import BlogFrontend
import NewsFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import WebContracts
import AnalyticsFrontend
import RedirectWebAdmin
import RedirectWebApp
import UserWebAdmin
import SystemWebAdmin
import FeatherWebAdmin
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
) async throws -> Hummingbird.Router<DefaultRequestContext> {

    let router = Hummingbird.Router(context: DefaultRequestContext.self)
    let apiBuilder = APIBuilder(apiBaseURL: environment.apiBaseURL)
    let mediaResolver = MediaResolver(
        mediaBaseURL: environment.publicOrigins.mediaBaseURL
    )

    router.addMiddleware {
        LogRequestsMiddleware(Logger.current.logLevel)
        WebAppAnalyticsLogMiddleware(
            apiBaseURL: environment.apiBaseURL,
            logFilter: WebAppAnalyticsLogFilter()
        )
        HTTPErrorMiddleware<DefaultRequestContext>()
        RedirectRuleMiddleware(
            siteBaseURL: environment.publicOrigins.siteBaseURL,
            resolver: DefaultRedirectRuleResolver(
                apiBaseURL: environment.apiBaseURL
            )
        )
    }

    router.get("/health") { _, _ in
        Response(status: .ok)
    }

    let systemRoutes = SystemWebAdmin.Router.Routes.standard
    let redirectRoutes = RedirectWebAdmin.Router.Routes.standard
    var adminEvents = EventRegistry()
    WebFrontend.WebEventHandlers.register(in: &adminEvents)
    BlogFrontend.BlogEventHandlers.register(in: &adminEvents)
    NewsFrontend.NewsEventHandlers.register(in: &adminEvents)
    BlogAdminDashboardEventHandlers.register(
        in: &adminEvents,
        environment: environment
    )
    WebAdminDashboardEventHandlers.register(
        in: &adminEvents,
        environment: environment
    )
    RedirectWebAdmin.Event.Handlers.register(
        in: &adminEvents,
        environment: environment,
        routes: redirectRoutes
    )
    AnalyticsAdminDashboardEventHandlers.register(
        in: &adminEvents,
        environment: environment
    )
    SystemWebAdmin.Event.Handlers.register(
        in: &adminEvents,
        routes: systemRoutes
    )
    AccountAdminMenuEventHandlers.register(in: &adminEvents)
    AuthAdminMenuEventHandlers.register(in: &adminEvents)
    UserModule.Event.Handlers.register(in: &adminEvents)
    MediaAdminMenuEventHandlers.register(in: &adminEvents)
    AnalyticsAdminMenuEventHandlers.register(in: &adminEvents)
    BlogAdminMenuEventHandlers.register(in: &adminEvents)
    NewsAdminMenuEventHandlers.register(in: &adminEvents)
    NewsletterRichContentEditorEventHandlers.register(in: &adminEvents)
    ContactRichContentEditorEventHandlers.register(in: &adminEvents)
    NewsletterAdminMenuEventHandlers.register(in: &adminEvents)
    ContactAdminMenuEventHandlers.register(in: &adminEvents)
    WebAdminMenuEventHandlers.register(in: &adminEvents)
    let richContentEditorBlocks =
        (try? await adminEvents.trigger(
            event: AdminRichContentEditorBlockProvider(),
            using: SystemWebAdmin.Admin.Menu.Context(
                path: "",
                permissions: []
            )
        )
        .compactMap { $0 }) ?? []
    let renderingEngine = DefaultRenderingEngine(
        publicOrigins: environment.publicOrigins,
        adminEvents: adminEvents,
        richContentEditorBlocks: richContentEditorBlocks,
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
        environment: environment,
        renderingEngine: renderingEngine,
        adminEvents: adminEvents,
        apiBuilder: apiBuilder,
        systemRoutes: systemRoutes,
        redirectRoutes: redirectRoutes
    )

    return router
}
