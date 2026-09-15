import FeatherAdmin
import Hummingbird

protocol AdminViewDashboardController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewDashboardController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/",
            use: getHome
        )
    }
}
