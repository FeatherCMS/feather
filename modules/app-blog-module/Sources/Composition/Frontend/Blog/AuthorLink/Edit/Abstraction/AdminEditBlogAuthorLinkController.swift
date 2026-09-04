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

protocol AdminEditBlogAuthorLinkController: Sendable {

    func getEditBlogAuthorLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogAuthorLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditBlogAuthorLinkController {

    func route(
        on router: Router<DefaultRequestContext>
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
