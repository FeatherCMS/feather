import SystemModule
import UserModule
import RedirectModule
import AuthModule
import ContactModule
import Environment
import FeatherWebShared
import Foundation
import FeatherModuleKit
import WebApplication
import BlogWebAdmin
import BlogWebApp
import NewsWebApp
import NewsWebAdmin
import MediaWebAdmin
import ContactWebAdmin
import ContactWebApp
import NewsletterWebAdmin
import NewsletterWebApp
import WebModuleWebAdmin
import WebModule
import WebModuleWebApp
import AnalyticsWebAdmin
import AnalyticsWebApp
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
    templateOptions: [PageTemplateOption],
    templateDefinitions: [TemplateDefinition],
    templatePaths: [URL]
) async throws -> Hummingbird.Router<DefaultRequestContext> {

    let router = Hummingbird.Router(context: DefaultRequestContext.self)
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
    let newsRoutes = NewsWebAdmin.Router.Routes.standard
    var adminEvents = EventRegistry()
    WebModuleWebApp.EventHandlers.register(in: &adminEvents)
    BlogWebApp.Event.Handlers.register(in: &adminEvents)
    NewsWebApp.NewsEventHandlers.register(in: &adminEvents)
    BlogWebAdmin.Event.Handlers.registerDashboard(
        in: &adminEvents,
        environment: environment
    )
    WebModule.Event.Handlers.registerDashboard(
        in: &adminEvents,
        environment: environment
    )
    RedirectModule.Event.Handlers.register(
        in: &adminEvents,
        environment: environment,
        routes: redirectRoutes
    )
    AnalyticsWebAdmin.Event.Handlers.registerDashboard(
        in: &adminEvents,
        environment: environment
    )
    SystemWebAdmin.Event.Handlers.register(
        in: &adminEvents,
        routes: systemRoutes
    )
    AccountWebAdmin.Event.Handlers.register(in: &adminEvents)
    AuthWebAdmin.Event.Handlers.registerMenu(in: &adminEvents)
    UserModule.Event.Handlers.register(in: &adminEvents)
    MediaWebAdmin.Event.Handlers.register(in: &adminEvents)
    AnalyticsWebAdmin.Event.Handlers.registerMenu(in: &adminEvents)
    BlogWebAdmin.Event.Handlers.registerMenu(in: &adminEvents)
    NewsWebAdmin.Menu.Provider.register(in: &adminEvents)
    NewsWebAdmin.Event.Handlers.registerMenu(
        in: &adminEvents,
        routes: newsRoutes
    )
    NewsletterWebAdmin.Event.Handlers.registerRichContentEditor(
        in: &adminEvents
    )
    ContactWebAdmin.Event.Handlers.registerRichContentEditor(
        in: &adminEvents
    )
    NewsletterWebAdmin.Event.Handlers.registerMenu(in: &adminEvents)
    ContactWebAdmin.Event.Handlers.registerMenu(in: &adminEvents)
    WebModule.Event.Handlers.registerMenu(in: &adminEvents)
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
    WebModuleWebApp.PublicContentEventHandlers.register(
        in: &publicContentEvents
    )
    WebModuleWebApp.MarkdownEventHandlers.register(in: &publicContentEvents)
    BlogWebApp.PublicContent.Event.Handlers.register(in: &publicContentEvents)
    NewsWebApp.NewsWebPublicContentEventHandlers.register(
        in: &publicContentEvents
    )

    ContactMarkdownEventHandlers.register(
        in: &publicContentEvents,
        api: ContactWebApp.API.Client(environment: environment)
    )
    NewsletterWebApp.Event.Handlers.registerMarkdown(in: &publicContentEvents)

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
            middleware: AuthMiddleware(
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
        systemRoutes: systemRoutes,
        redirectRoutes: redirectRoutes,
        newsRoutes: newsRoutes
    )

    return router
}
