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

protocol AdminAddBlogAuthorLinkController: Sendable {

    func getAddBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddBlogAuthorLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
