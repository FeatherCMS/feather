import FeatherAdmin
import Hummingbird

protocol AdminGetAccountHomeController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAccountHomeController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/account/",
            use: getHome
        )
    }
}
