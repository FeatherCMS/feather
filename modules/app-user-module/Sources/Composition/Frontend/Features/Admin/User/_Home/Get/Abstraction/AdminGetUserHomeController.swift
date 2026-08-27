import FeatherAdmin
import Hummingbird

protocol AdminGetUserHomeController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetUserHomeController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/user/",
            use: getHome
        )
    }
}
