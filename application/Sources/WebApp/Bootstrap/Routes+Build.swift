import SystemModule
import UserModule
import RedirectModule
import AuthModule
import ContactModule
import AnalyticsModule
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
    templateDefinitions: [WebModule.Template.Definition],
    templatePaths: [URL]
) async throws -> Hummingbird.Router<DefaultRequestContext> {

    let router = Hummingbird.Router(context: DefaultRequestContext.self)
    let mediaResolver = MediaResolver(
        mediaBaseURL: environment.publicOrigins.mediaBaseURL
    )

    router.addMiddleware {
        LogRequestsMiddleware(Logger.current.logLevel)
        Log.Middleware(
            environment: environment,
            logFilter: WebAppAnalyticsLogFilter()
        )
        HTTPErrorMiddleware<DefaultRequestContext>()
        RedirectRuleMiddleware(
            siteBaseURL: environment.publicOrigins.siteBaseURL,
            resolver: DefaultRedirectRuleResolver(environment: environment)
        )
    }

    router.get("/health") { _, _ in
        Response(status: .ok)
    }

    let adminRoot = WebRoute.root.appending(pathComponent: "admin")
    let systemRoutes = SystemWebAdmin.Router.Routes.standard
    let redirectRoutes = RedirectWebAdmin.Router.Routes.standard
    let authRoutes = AuthWebAdmin.Router.Routes.standard
    let userRoutes = UserWebAdmin.Router.Routes.standard
    let mediaRoutes = MediaWebAdmin.Router.Routes.standard
    let newsRoutes = NewsWebAdmin.Router.Routes(
        admin: adminRoot,
        mediaAssetList: mediaRoutes.assetList
    )
    let newsletterRoutes = NewsletterWebAdmin.Router.Routes.standard
    let webAdminRoutes = WebModuleWebAdmin.Router.Routes(
        admin: adminRoot,
        root: adminRoot.appending(pathComponent: "web"),
        mediaAssetList: mediaRoutes.assetList
    )
    let blogRoutes = BlogWebAdmin.Router.Routes(
        root: adminRoot,
        mediaAssetList: mediaRoutes.assetList
    )
    let contactRoutes = Contact.Router.Routes(
        admin: adminRoot,
        root: adminRoot.appending(pathComponent: "contact")
    )
    let accountRoutes = AccountWebAdmin.Router.Routes(
        admin: adminRoot,
        mediaAssetList: mediaRoutes.assetList,
        userIdentityRoot: userRoutes.user
            .appending(pathComponent: "identities"),
        authMagicLinksRoot: authRoutes.auth
            .appending(pathComponent: "magic-links")
    )
    var adminEvents = EventRegistry()
    WebModuleWebApp.Event.Handlers.register(in: &adminEvents)
    BlogWebApp.Event.Handlers.register(in: &adminEvents)
    NewsWebApp.Event.Handlers.register(in: &adminEvents)
    BlogWebAdmin.Event.Handlers.registerDashboard(
        in: &adminEvents,
        environment: environment
    )
    WebModuleWebAdmin.Event.Handlers.registerDashboard(
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
    BlogWebAdmin.Event.Handlers.registerMenu(
        in: &adminEvents,
        routes: blogRoutes
    )
    NewsWebAdmin.Menu.Provider.register(in: &adminEvents)
    NewsWebAdmin.Event.Handlers.registerMenu(
        in: &adminEvents,
        routes: newsRoutes
    )
    NewsletterWebAdmin.Event.Handlers.registerRichContentEditor(
        in: &adminEvents,
        routes: newsletterRoutes
    )
    ContactWebAdmin.Event.Handlers.registerRichContentEditor(
        in: &adminEvents,
        routes: contactRoutes
    )
    NewsletterWebAdmin.Event.Handlers.registerMenu(
        in: &adminEvents,
        routes: newsletterRoutes
    )
    ContactWebAdmin.Event.Handlers.registerMenu(
        in: &adminEvents,
        routes: contactRoutes
    )
    WebModuleWebAdmin.Event.Handlers.registerMenu(
        in: &adminEvents,
        routes: webAdminRoutes
    )
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
    WebModuleWebApp.PublicContent.Event.Handlers.register(
        in: &publicContentEvents
    )
    WebModuleWebApp.Event.Handlers.registerMarkdown(in: &publicContentEvents)
    BlogWebApp.PublicContent.Event.Handlers.register(in: &publicContentEvents)
    NewsWebApp.PublicContent.Event.Handlers.register(
        in: &publicContentEvents
    )

    let contactSubmissionRoutes = Submission.Router.Routes.standard
    let newsletterSubmissionRoute = Campaign.Subscription.Route.standard
    ContactWebApp.Event.Handlers.registerMarkdown(
        in: &publicContentEvents,
        api: ContactWebApp.API.Client(environment: environment),
        routes: contactSubmissionRoutes
    )
    NewsletterWebApp.Event.Handlers.registerMarkdown(
        in: &publicContentEvents,
        submissionRoute: newsletterSubmissionRoute
    )

    let authRouter = router.add(
        middleware: DefaultAuthMiddleware(
            environment: environment,
            secureCookies: environment.publicOrigins.usesSecureCookies
        )
    )
    buildAppRoutes(
        router: router,
        environment: environment,
        contactSubmissionRoutes: contactSubmissionRoutes,
        newsletterSubmissionRoute: newsletterSubmissionRoute,
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
        newsRoutes: newsRoutes,
        blogRoutes: blogRoutes,
        contactRoutes: contactRoutes,
        newsletterRoutes: newsletterRoutes,
        authRoutes: authRoutes,
        userRoutes: userRoutes,
        mediaRoutes: mediaRoutes,
        accountRoutes: accountRoutes,
        webAdminRoutes: webAdminRoutes
    )

    return router
}
