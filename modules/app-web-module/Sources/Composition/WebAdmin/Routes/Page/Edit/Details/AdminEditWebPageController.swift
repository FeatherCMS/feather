import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebPageController: Sendable {

    func getEditWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
