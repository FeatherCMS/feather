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

protocol AdminEditBlogTagController: Sendable {

    func getEditBlogTag(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogTag(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditBlogTagController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/tags/{id}/edit/",
            use: getEditBlogTag
        )
        router.post(
            "/admin/blog/tags/{id}/edit/",
            use: postEditBlogTag
        )
    }
}
