import Hummingbird
import HummingbirdAuth
import Logging
import WebStandards

func buildRouter(
    logger: Logger,
    styleshetCollector: GlobalStylesheetCollector,
    environment: AppEnvironment
) -> Router<AppRequestContext> {

    let router = Router(context: AppRequestContext.self)

    router.addMiddleware {
        LogRequestsMiddleware(logger.logLevel)
        WebAppAnalyticsLogMiddleware(apiBaseURL: environment.apiBaseURL)
        HTTPErrorMiddleware()
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

    let appClient = ApplicationAPI(
        apiBaseURL: environment.apiBaseURL
    )
    let loginRepository = AppLoginUserOpenAPIRepository(
        appClient: appClient
    )
    let logoutRepository = AppLogoutUserOpenAPIRepository(
        appClient: appClient
    )
    let publicContentRepository = AppPublicContentOpenAPIRepository(
        api: appClient
    )
    let renderingEngine = DefaultRenderingEngine(
        publicOrigins: environment.publicOrigins
    )
    let themeRenderer = ThemeRenderer()
    let contentRenderer = MarkdownContentRenderer(logger: logger)
    let themeContextFactory = ThemeContextFactory(
        publicOrigins: environment.publicOrigins,
        contentRenderer: contentRenderer
    )

    let authRouter = router.add(middleware: AuthMiddleware())
    buildAppRoutes(
        router: router,
        authRouter: authRouter,
        renderingEngine: renderingEngine,
        themeRenderer: themeRenderer,
        themeContextFactory: themeContextFactory,
        loginRepository: loginRepository,
        logoutRepository: logoutRepository,
        publicContentRepository: publicContentRepository,
        styleshetCollector: styleshetCollector
    )

    // MARK: - admin

    let adminRouter = authRouter.add(middleware: AdminAuthMiddleware())

    Admin(renderingEngine: renderingEngine)
        .route(on: adminRouter)

    return router
}
