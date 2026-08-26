import FeatherAdmin
import Hummingbird

protocol AdminGetSystemHomeController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetSystemHomeController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/",
            use: getHome
        )
    }
}
