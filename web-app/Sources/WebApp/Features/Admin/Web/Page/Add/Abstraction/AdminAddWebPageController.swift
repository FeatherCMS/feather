import HTML
import Hummingbird

protocol AdminAddWebPageController: Sendable {

    func getAddWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddWebPageController {

    func route(
        on router: Router<AppRequestContext>
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
