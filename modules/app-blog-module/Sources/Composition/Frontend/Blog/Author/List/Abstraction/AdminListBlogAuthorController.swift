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

protocol AdminListBlogAuthorController: Sendable {

    func getBlogAuthors(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getBlogAuthorsBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogAuthorsBulkRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogAuthorStatus(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListBlogAuthorController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/authors",
            use: getBlogAuthors
        )
        router.get(
            "/admin/blog/authors/bulk-remove/",
            use: getBlogAuthorsBulkRemoveConfirmation
        )
        router.post(
            "/admin/blog/authors/bulk-remove/",
            use: postBlogAuthorsBulkRemove
        )
        router.post(
            "/admin/blog/authors/{id}/status/",
            use: postBlogAuthorStatus
        )
    }
}
