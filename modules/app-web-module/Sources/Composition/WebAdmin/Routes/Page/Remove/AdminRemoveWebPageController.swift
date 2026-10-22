import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebPageController: Sendable {

    func postRemoveWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebPageController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post("/admin/web/pages/remove/", use: postRemoveWebPage)
    }
}
