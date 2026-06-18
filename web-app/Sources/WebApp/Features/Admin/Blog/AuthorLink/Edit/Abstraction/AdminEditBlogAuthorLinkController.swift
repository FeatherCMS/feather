import HTML
import Hummingbird

protocol AdminEditBlogAuthorLinkController: Sendable {

    func getEditBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditBlogAuthorLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/{itemId}/edit/",
            use: getEditBlogAuthorLink
        )
        router.post(
            "/admin/blog/authors/{id}/links/{itemId}/edit/",
            use: postEditBlogAuthorLink
        )
    }
}
