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

protocol AdminRemoveBlogTagController: Sendable {

    func getRemoveBlogTag(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogTag(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogTagController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/tags/{id}/remove/",
            use: getRemoveBlogTag
        )
        router.post(
            "/admin/blog/tags/{id}/remove/",
            use: postRemoveBlogTag
        )
    }
}
