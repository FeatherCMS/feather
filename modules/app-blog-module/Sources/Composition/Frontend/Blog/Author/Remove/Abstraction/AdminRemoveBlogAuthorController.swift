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

protocol AdminRemoveBlogAuthorController: Sendable {

    func getRemoveBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogAuthorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/remove/",
            use: getRemoveBlogAuthor
        )
        router.post(
            "/admin/blog/authors/{id}/remove/",
            use: postRemoveBlogAuthor
        )
    }
}
