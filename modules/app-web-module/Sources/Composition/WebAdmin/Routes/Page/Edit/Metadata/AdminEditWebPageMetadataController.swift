import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebPageMetadataController: Sendable {

    func getEditWebPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
