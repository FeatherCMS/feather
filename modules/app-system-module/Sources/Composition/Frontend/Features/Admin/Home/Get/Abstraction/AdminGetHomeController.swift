import FeatherAdmin
import Hummingbird

protocol AdminGetHomeController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetHomeController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/",
            use: getHome
        )
    }
}
