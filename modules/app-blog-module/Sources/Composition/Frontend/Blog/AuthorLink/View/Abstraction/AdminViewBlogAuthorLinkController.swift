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

protocol AdminViewBlogAuthorLinkController: Sendable {

    func getBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewBlogAuthorLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/{itemId}/",
            use: getBlogAuthorLink
        )
    }
}
