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

protocol AdminRemoveBlogAuthorLinkController: Sendable {

    func getRemoveBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogAuthorLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/{itemId}/remove/",
            use: getRemoveBlogAuthorLink
        )
        router.post(
            "/admin/blog/authors/{id}/links/{itemId}/remove/",
            use: postRemoveBlogAuthorLink
        )
    }
}
