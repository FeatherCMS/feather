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

protocol AdminAddBlogAuthorLinkController: Sendable {

    func getAddBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddBlogAuthorLinkController {

    func route(
        on router: Router<AppRequestContext>
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
