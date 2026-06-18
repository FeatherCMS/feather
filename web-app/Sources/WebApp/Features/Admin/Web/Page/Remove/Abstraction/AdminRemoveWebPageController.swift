import HTML
import Hummingbird

protocol AdminRemoveWebPageController: Sendable {

    func getRemoveWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebPageController {

    func route(
        on router: Router<AppRequestContext>
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
