import FeatherAdmin
import Hummingbird

protocol AdminViewSystemOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewSystemOverviewController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/system/",
            use: getOverview
        )
    }
}
