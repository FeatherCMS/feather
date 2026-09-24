import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebPageController: Sendable {

    func getWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewWebPageController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/pages/{id}/",
            use: getWebPage
        )
    }
}
