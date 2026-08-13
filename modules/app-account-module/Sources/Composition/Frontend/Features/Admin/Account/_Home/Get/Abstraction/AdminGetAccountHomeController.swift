import FeatherAdmin
import Hummingbird

protocol AdminGetAccountHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAccountHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/account/",
            use: getHome
        )
    }
}
