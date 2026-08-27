import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebPageController: Sendable {

    func getAddWebPage(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddWebPage(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddWebPageController {

    func route(
        on router: Router<DefaultRequestContext>
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
