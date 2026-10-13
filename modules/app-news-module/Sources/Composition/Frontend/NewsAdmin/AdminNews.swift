public import FeatherAdmin
public import Hummingbird
import NewsContracts

public struct AdminNews: Sendable {
    private let apiBuilder: NewsAPIBuilder
    private let renderingEngine: any RenderingEngine

    public init(
        apiBuilder: NewsAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get("/admin/news/", use: home)

        AdminNewsArticles(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminNewsCategories(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }

    private func home(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "News",
            content: NewsHomePage(
                canViewArticles: context.isCurrentUserAllowed(
                    to: NewsPermissions.Articles.list
                ),
                canViewCategories: context.isCurrentUserAllowed(
                    to: NewsPermissions.Categories.list
                )
            )
        )
    }
}
