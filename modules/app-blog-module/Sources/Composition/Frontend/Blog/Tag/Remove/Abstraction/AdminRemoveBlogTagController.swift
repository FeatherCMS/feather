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

protocol AdminRemoveBlogTagController: Sendable {

    func postRemoveBlogTag(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogTagController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post("/admin/blog/tags/remove/", use: postRemoveBlogTag)
    }
}
