import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminListBlogAuthorLinkController: Sendable {

    func getBlogAuthorLinks(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func getBlogAuthorLinksRemoveConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postBlogAuthorLinksRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListBlogAuthorLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
