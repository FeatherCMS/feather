import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebPageController: Sendable {

    func getEditWebPage(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditWebPage(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditWebPageController {

    func route(
        on router: Router<DefaultRequestContext>
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
