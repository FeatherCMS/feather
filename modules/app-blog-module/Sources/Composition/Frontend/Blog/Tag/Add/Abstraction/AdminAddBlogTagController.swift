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

protocol AdminAddBlogTagController: Sendable {

    func getAddBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddBlogTagController {

    func route(
        on router: Router<AppRequestContext>
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
