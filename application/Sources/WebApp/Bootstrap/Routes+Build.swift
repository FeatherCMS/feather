import SystemModule
import FeatherWebShared
import Foundation
import FeatherModuleKit
import WebApplication
import BlogWebAdmin
import BlogWebApp
import NewsFrontend
import MediaWebAdmin
import ContactWebAdmin
import ContactWebApp
import NewsletterFrontend
import WebModuleWebAdmin
import WebModule
import WebModuleWebApp
import AnalyticsFrontend
import RedirectWebAdmin
import RedirectWebApp
import UserWebAdmin
import SystemWebAdmin
import FeatherWebAdmin
import FeatherWebApp
import Hummingbird
import HummingbirdAuth
import AuthWebAdmin
import AuthWebApp
import AccountWebAdmin
import AccountWebApp
import Logging

func buildRouter(
    environment: AppEnvironment,
    templateOptions: [WebPageTemplateOption],
    templateDefinitions: [WebTemplateDefinition],
    templatePaths: [URL]
) async throws -> Hummingbird.Router<DefaultRequestContext> {

    let router = Hummingbird.Router(context: DefaultRequestContext.self)
    let apiBuilder = APIBuilder(environment: environment)
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
    WebModuleWebApp.WebEventHandlers.register(in: &adminEvents)
    BlogWebApp.Event.Handlers.register(in: &adminEvents)
    NewsFrontend.NewsEventHandlers.register(in: &adminEvents)
    BlogWebAdmin.Event.Handlers.registerDashboard(
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
    AccountWebAdmin.Event.Handlers.register(in: &adminEvents)
    AuthAdminMenuEventHandlers.register(in: &adminEvents)
    UserModule.Event.Handlers.register(in: &adminEvents)
    MediaWebAdmin.Event.Handlers.register(in: &adminEvents)
    AnalyticsAdminMenuEventHandlers.register(in: &adminEvents)
    BlogWebAdmin.Event.Handlers.registerMenu(in: &adminEvents)
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
        adminEvents: adminEvents,
        richContentEditorBlocks: richContentEditorBlocks,
        adminPageRenderContextProvider: DefaultAdminPageRenderContextProvider(
            events: adminEvents,
            environment: environment,
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
    BlogWebApp.PublicContent.Event.Handlers.register(in: &publicContentEvents)
    NewsWebPublicContentEventHandlers.register(in: &publicContentEvents)

    ContactMarkdownEventHandlers.register(
        in: &publicContentEvents,
        api: ContactAppAPIClient(apiBaseURL: environment.apiBaseURL)
    )
    NewsletterMarkdownEventHandlers.register(in: &publicContentEvents)

    let authRouter = router.add(
        middleware: DefaultAuthMiddleware(
            environment: environment,
            secureCookies: environment.publicOrigins.usesSecureCookies
        )
    )
    buildAppRoutes(
        router: router,
        environment: environment,
        publicPageRenderer: DefaultPublicPageRenderer(
            publicOrigins: environment.publicOrigins
        ),
        themeRenderer: themeRenderer,
        publicContentEvents: publicContentEvents,
        apiBuilder: apiBuilder,
        mediaResolver: mediaResolver,
        publicOrigins: environment.publicOrigins
    )

    AuthWebApp.Router(
        templateRenderer: try AuthWebApp.MustacheTemplateRenderer(),
        environment: environment,
        usesSecureCookies: environment.publicOrigins.usesSecureCookies
    )
    .route(on: router)

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
