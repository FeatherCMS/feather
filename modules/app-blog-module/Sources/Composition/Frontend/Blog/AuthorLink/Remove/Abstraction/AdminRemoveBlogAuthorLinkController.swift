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
import WebComponents
import WebBuilders

protocol AdminRemoveBlogAuthorLinkController: Sendable {

    func getRemoveBlogAuthorLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogAuthorLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogAuthorLinkController {

    func route(
        on router: Router<DefaultRequestContext>
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
