import HTML
import Hummingbird

protocol AdminEditWebPageController: Sendable {

    func getEditWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditWebPageController {

    func route(
        on router: Router<AppRequestContext>
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
