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

protocol AdminAddBlogTagController: Sendable {

    func getAddBlogTag(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogTag(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddBlogTagController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/tags/add/",
            use: getAddBlogTag
        )
        router.post(
            "/admin/blog/tags/add/",
            use: postAddBlogTag
        )
    }
}
