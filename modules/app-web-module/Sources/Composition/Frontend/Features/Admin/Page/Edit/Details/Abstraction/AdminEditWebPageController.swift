import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebPageController: Sendable {

    func getEditWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditWebPageController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/pages/{id}/edit/",
            use: getEditWebPage
        )
        router.post(
            "/admin/web/pages/{id}/edit/",
            use: postEditWebPage
        )
    }
}
