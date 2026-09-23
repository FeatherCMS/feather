public import FeatherAdmin
public import Hummingbird

public protocol AdminViewAnalyticsNotFoundController: Sendable {

    func getNotFound(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsNotFoundController {

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            AnalyticsAdminRoutes.notFound,
            use: getNotFound
        )
    }
}
