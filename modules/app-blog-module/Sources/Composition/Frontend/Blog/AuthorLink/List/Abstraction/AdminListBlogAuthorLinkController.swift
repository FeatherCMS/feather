import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

protocol AdminListBlogAuthorLinkController: Sendable {

    func getBlogAuthorLinks(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getBlogAuthorLinksRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogAuthorLinksRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListBlogAuthorLinkController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/",
            use: getBlogAuthorLinks
        )
        router.get(
            "/admin/blog/authors/{id}/links/remove/",
            use: getBlogAuthorLinksRemoveConfirmation
        )
        router.post(
            "/admin/blog/authors/{id}/links/remove/",
            use: postBlogAuthorLinksRemove
        )
    }
}
