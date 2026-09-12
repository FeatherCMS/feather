import FeatherAdmin
import Hummingbird

protocol AdminGetSystemOverviewController: Sendable {

    func getHome(
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
            use: getHome
        )
    }
}
