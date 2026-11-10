public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
public import FeatherModuleKit
import NewsModule
import WebModule
import WebModuleWebAdmin

public struct Router: Sendable {
    private let environment: AppEnvironment
    private let renderingEngine: any RenderingEngine
    private let routes: Routes
    private let adminEvents: any EventPublisher

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher = EventRegistry(),
        routes: Routes = .standard
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
        self.adminEvents = adminEvents
        self.routes = routes
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(routes.news.routerPath, use: home)

        let articleRoutes = Article.Router.Routes(
            root: routes.articles,
            breadcrumb: routes.breadcrumb,
            mediaAssetList: routes.mediaAssetList
        )
        Article.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: articleRoutes
        )
        .route(on: router)

        let categoryRoutes = Category.Router.Routes(
            root: routes.categories,
            breadcrumb: routes.breadcrumb,
            mediaAssetList: routes.mediaAssetList
        )
        Category.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: categoryRoutes
        )
        .route(on: router)

        Router.Metadata.register(
            router: router,
            environment: environment,
            renderingEngine: renderingEngine,
            events: adminEvents,
            articleRoutes: articleRoutes,
            categoryRoutes: categoryRoutes
        )
    }

    private func home(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "News",
            content: News.Home.Page(
                routes: routes,
                canViewArticles: context.isCurrentUserAllowed(
                    to: Article.Permissions.list
                ),
                canViewCategories: context.isCurrentUserAllowed(
                    to: Category.Permissions.list
                )
            )
        )
    }
}
