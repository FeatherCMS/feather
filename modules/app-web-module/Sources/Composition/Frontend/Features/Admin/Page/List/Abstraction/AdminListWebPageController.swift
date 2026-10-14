import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebPageController: Sendable {

    func getWebPages(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postWebPagesRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postWebPageStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListWebPageController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/pages",
            use: getWebPages
        )
        router.post(
            "/admin/web/pages/remove/",
            use: postWebPagesRemove
        )
        router.post(
            "/admin/web/pages/{id}/status/",
            use: postWebPageStatus
        )
    }
}
