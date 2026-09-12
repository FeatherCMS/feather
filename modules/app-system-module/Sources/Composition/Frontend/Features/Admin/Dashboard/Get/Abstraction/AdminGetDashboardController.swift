import FeatherAdmin
import Hummingbird

protocol AdminGetDashboardController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetDashboardController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/",
            use: getHome
        )
    }
}
