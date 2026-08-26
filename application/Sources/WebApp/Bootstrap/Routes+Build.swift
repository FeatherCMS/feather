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
import AuthAppAPI
import AccountFrontend
import Logging
import WebStandards
import WebApplication

func buildRouter(
    styleshetCollector: GlobalStylesheetCollector,
    environment: AppEnvironment,
    referenceTypeOptions: [WebMetadataReferenceTypeOption],
    templateOptions: [WebPageTemplateOption]
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

    router.get("/admin-navigation.js") { _, _ in
        let script = """
            (function () {
                var key = "adminMenuCollapsed";
                var menuToggle = document.getElementById("menuToggle");
                var toastNode = document.getElementById("admin-toast");
                var mobileMedia = window.matchMedia("(max-width: 599px)");

                if (menuToggle) {
                    try {
                        var collapsed = window.localStorage.getItem(key);
                        if (collapsed === "1") { menuToggle.checked = true; }
                    } catch (_) {}

                    menuToggle.addEventListener("change", function () {
                        try {
                            window.localStorage.setItem(key, menuToggle.checked ? "1" : "0");
                        } catch (_) {}
                    });

                    document.querySelectorAll("nav .sub-menu a[href], nav > ul > li a[href]").forEach(function (link) {
                        link.addEventListener("click", function () {
                            if (!mobileMedia.matches) { return; }
                            menuToggle.checked = false;
                            try {
                                window.localStorage.setItem(key, "0");
                            } catch (_) {}
                        });
                    });
                }

                if (!toastNode || !window.toast) { return; }

                window.toast.show({
                    type: toastNode.dataset.toastType || "success",
                    title: toastNode.dataset.toastTitle || "Success",
                    message: toastNode.dataset.toastMessage || "",
                    position: toastNode.dataset.toastPosition || "top-right",
                    duration: 3000,
                    persistent: false
                });

                try {
                    var url = new URL(window.location.href);
                    [
                        "toastType",
                        "toastTitle",
                        "toastMessage",
                        "toastPosition"
                    ].forEach(function (queryKey) {
                        url.searchParams.delete(queryKey);
                    });
                    var next = url.pathname;
                    var search = url.searchParams.toString();
                    if (search) {
                        next += "?" + search;
                    }
                    if (url.hash) {
                        next += url.hash;
                    }
                    window.history.replaceState(window.history.state, "", next);
                } catch (_) {}
            })();
            """
        return Response(
            status: .ok,
            headers: [
                .contentType: "application/javascript; charset=utf-8",
                .cacheControl: "no-cache",
            ],
            body: .init(byteBuffer: ByteBuffer(string: script))
        )
    }

    let appClient = AppAPI(
        apiBaseURL: environment.apiBaseURL
    )
    let authAppClient = AuthAppAPIClient(
        apiBaseURL: environment.apiBaseURL
    )
    let publicContentRepository = appClient
    var adminEvents = EventRegistry()
    EventHandlers.register(in: &adminEvents)
    AdminMenuEventHandlers.register(in: &adminEvents)
    AuthAdminMenuEventHandlers.register(in: &adminEvents)
    AccountAdminMenuEventHandlers.register(in: &adminEvents)
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
    let themeRenderer = ThemeRenderer()
    var publicContentEvents = EventRegistry()
    WebPublicContentEventHandlers.register(in: &publicContentEvents)
    BlogWebPublicContentEventHandlers.register(in: &publicContentEvents)
    NewsWebPublicContentEventHandlers.register(in: &publicContentEvents)

    MarkdownBlockRendererEventHandlers.register(
        in: &publicContentEvents,
        api: appClient
    )

    let authRouter = router.add(
        middleware: AuthMiddleware<DefaultRequestContext>(
            secureCookies: environment.publicOrigins.usesSecureCookies
        ) { sessionToken in
            let api = AppAPI(
                apiBaseURL: environment.apiBaseURL,
                sessionToken: sessionToken
            )
            return try await api.withAuthOpenAPIRepositoryErrorMapping {
                client in
                let response = try await client.authMe()
                let payload = try response.ok.body.json
                return AccountModel(
                    user: .init(id: payload.user.id),
                    permissions: payload.permissions,
                    roles: payload.roles
                )
            }
        }
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
