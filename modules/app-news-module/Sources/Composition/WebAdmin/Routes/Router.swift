public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
import NewsModule

public struct Router: Sendable {
    private let environment: AppEnvironment
    private let renderingEngine: any RenderingEngine
    private let routes: Routes

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Routes = .standard
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
        self.routes = routes
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(routes.news.routerPath, use: home)

        Article.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: .init(root: routes.articles, breadcrumb: routes.breadcrumb)
        )
        .route(on: router)

        Category.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: .init(
                root: routes.categories,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)
    }

    private func home(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "News",
            content: NewsHomePage(
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
