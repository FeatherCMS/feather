import HTML
import Hummingbird

protocol AdminAddBlogAuthorLinkController: Sendable {

    func getAddBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddBlogAuthorLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/add/",
            use: getAddBlogAuthorLink
        )
        router.post(
            "/admin/blog/authors/{id}/links/add/",
            use: postAddBlogAuthorLink
        )
    }
}
