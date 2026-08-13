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

protocol AdminGetBlogTagController: Sendable {

    func getBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogTagController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/tags/{id}/",
            use: getBlogTag
        )
    }
}
