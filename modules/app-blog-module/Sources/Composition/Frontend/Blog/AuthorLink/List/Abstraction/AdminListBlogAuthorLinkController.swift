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
import WebStandards

protocol AdminListBlogAuthorLinkController: Sendable {

    func getBlogAuthorLinks(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getBlogAuthorLinksBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogAuthorLinksBulkRemove(
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
            "/admin/blog/authors/{id}/links/bulk-remove/",
            use: getBlogAuthorLinksBulkRemoveConfirmation
        )
        router.post(
            "/admin/blog/authors/{id}/links/bulk-remove/",
            use: postBlogAuthorLinksBulkRemove
        )
    }
}
