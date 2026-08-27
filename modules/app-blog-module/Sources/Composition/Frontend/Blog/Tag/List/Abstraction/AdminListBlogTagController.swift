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

protocol AdminListBlogTagController: Sendable {

    func getBlogTags(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getBlogTagsBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogTagsBulkRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogTagStatus(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListBlogTagController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/tags",
            use: getBlogTags
        )
        router.get(
            "/admin/blog/tags/bulk-remove/",
            use: getBlogTagsBulkRemoveConfirmation
        )
        router.post(
            "/admin/blog/tags/bulk-remove/",
            use: postBlogTagsBulkRemove
        )
        router.post(
            "/admin/blog/tags/{id}/status/",
            use: postBlogTagStatus
        )
    }
}
