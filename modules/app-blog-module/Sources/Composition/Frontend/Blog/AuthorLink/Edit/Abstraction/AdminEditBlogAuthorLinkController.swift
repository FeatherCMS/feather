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

protocol AdminEditBlogAuthorLinkController: Sendable {

    func getEditBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditBlogAuthorLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/{itemId}/edit/",
            use: getEditBlogAuthorLink
        )
        router.post(
            "/admin/blog/authors/{id}/links/{itemId}/edit/",
            use: postEditBlogAuthorLink
        )
    }
}
