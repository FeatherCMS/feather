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

protocol AdminRemoveBlogAuthorController: Sendable {

    func postRemoveBlogAuthor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogAuthorController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post("/admin/blog/authors/remove/", use: postRemoveBlogAuthor)
    }
}
