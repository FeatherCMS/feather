import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveMenuItemController: Sendable {

    func postRemoveMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
