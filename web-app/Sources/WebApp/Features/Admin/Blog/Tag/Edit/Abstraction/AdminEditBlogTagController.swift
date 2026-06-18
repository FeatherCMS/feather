import HTML
import Hummingbird

protocol AdminEditBlogTagController: Sendable {

    func getEditBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditBlogTagController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/tags/{id}/edit/",
            use: getEditBlogTag
        )
        router.post(
            "/admin/blog/tags/{id}/edit/",
            use: postEditBlogTag
        )
    }
}
