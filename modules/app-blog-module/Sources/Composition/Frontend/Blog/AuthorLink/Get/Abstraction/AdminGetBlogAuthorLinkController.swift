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

protocol AdminGetBlogAuthorLinkController: Sendable {

    func getBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogAuthorLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/{itemId}/",
            use: getBlogAuthorLink
        )
    }
}
