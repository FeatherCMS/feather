import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebPageController: Sendable {

    func getRemoveWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebPageController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/pages/{id}/remove/",
            use: getRemoveWebPage
        )
        router.post(
            "/admin/web/pages/{id}/remove/",
            use: postRemoveWebPage
        )
    }
}
