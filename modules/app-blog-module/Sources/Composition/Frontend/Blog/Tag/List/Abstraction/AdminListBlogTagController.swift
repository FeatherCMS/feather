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

protocol AdminListBlogTagController: Sendable {

    func getBlogTags(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func getBlogTagsRemoveConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postBlogTagsRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postBlogTagStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListBlogTagController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/tags",
            use: getBlogTags
        )
        router.get(
            "/admin/blog/tags/remove/",
            use: getBlogTagsRemoveConfirmation
        )
        router.post(
            "/admin/blog/tags/remove/",
            use: postBlogTagsRemove
        )
        router.post(
            "/admin/blog/tags/{id}/status/",
            use: postBlogTagStatus
        )
    }
}
