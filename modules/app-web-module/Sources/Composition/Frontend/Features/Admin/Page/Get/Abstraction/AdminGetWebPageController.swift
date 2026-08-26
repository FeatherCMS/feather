import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminGetWebPageController: Sendable {

    func getWebPage(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebPageController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/pages/{id}/",
            use: getWebPage
        )
    }
}
