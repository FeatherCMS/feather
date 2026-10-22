import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditPageMetadataController: Sendable {

    func getEditPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
