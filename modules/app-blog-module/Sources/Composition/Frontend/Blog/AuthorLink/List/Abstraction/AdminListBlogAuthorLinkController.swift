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
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getBlogAuthorLinksBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postBlogAuthorLinksBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListBlogAuthorLinkController {

    func route(
        on router: Router<AppRequestContext>
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
