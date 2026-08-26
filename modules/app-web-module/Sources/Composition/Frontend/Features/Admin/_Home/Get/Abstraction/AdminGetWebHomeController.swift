import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminGetWebHomeController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebHomeController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/",
            use: getHome
        )
    }
}
