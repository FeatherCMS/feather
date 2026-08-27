import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebPageController: Sendable {

    func getRemoveWebPage(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveWebPage(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebPageController {

    func route(
        on router: Router<DefaultRequestContext>
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
