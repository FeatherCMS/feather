import HTML
import Hummingbird

protocol AdminEditBlogAuthorController: Sendable {

    func getEditBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditBlogAuthorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/edit/",
            use: getEditBlogAuthor
        )
        router.post(
            "/admin/blog/authors/{id}/edit/",
            use: postEditBlogAuthor
        )
    }
}
