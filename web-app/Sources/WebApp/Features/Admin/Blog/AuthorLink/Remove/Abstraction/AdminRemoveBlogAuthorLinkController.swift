import HTML
import Hummingbird

protocol AdminRemoveBlogAuthorLinkController: Sendable {

    func getRemoveBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogAuthorLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/{itemId}/remove/",
            use: getRemoveBlogAuthorLink
        )
        router.post(
            "/admin/blog/authors/{id}/links/{itemId}/remove/",
            use: postRemoveBlogAuthorLink
        )
    }
}
