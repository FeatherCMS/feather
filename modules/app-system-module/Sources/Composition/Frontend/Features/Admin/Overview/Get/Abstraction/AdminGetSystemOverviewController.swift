import FeatherAdmin
import Hummingbird

protocol AdminGetSystemOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetSystemOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/",
            use: getOverview
        )
    }
}
