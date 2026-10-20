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

protocol AdminRemoveBlogAuthorLinkController: Sendable {

    func postRemoveBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogAuthorLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            "/admin/blog/authors/{id}/links/remove/",
            use: postRemoveBlogAuthorLink
        )
    }
}
