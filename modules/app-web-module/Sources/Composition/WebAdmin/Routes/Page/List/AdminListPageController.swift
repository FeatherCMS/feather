import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminListPageController: Sendable {

    func getPages(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postPageStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
