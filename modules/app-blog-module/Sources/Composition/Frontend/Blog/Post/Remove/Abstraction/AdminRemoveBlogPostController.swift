import BlogAdminAPI
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminRemoveBlogPostController: Sendable {

    func postRemoveBlogPost(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogPostController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post("/admin/blog/posts/remove/", use: postRemoveBlogPost)
    }
}
