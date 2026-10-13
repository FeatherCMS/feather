import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebPageController: Sendable {

    func getAddWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddWebPageController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/pages/add/",
            use: getAddWebPage
        )
        router.post(
            "/admin/web/pages/add/",
            use: postAddWebPage
        )
    }
}
