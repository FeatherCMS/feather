public import FeatherAdmin
public import Hummingbird

public protocol AdminViewAnalyticsNotFoundController: Sendable {

    func getNotFound(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsNotFoundController {

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AnalyticsAdminRoutes.notFound,
            use: getNotFound
        )
    }
}
