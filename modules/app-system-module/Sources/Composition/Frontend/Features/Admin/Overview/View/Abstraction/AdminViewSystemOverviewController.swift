import FeatherAdmin
import Hummingbird

protocol AdminViewSystemOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewSystemOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/",
            use: getOverview
        )
    }
}
