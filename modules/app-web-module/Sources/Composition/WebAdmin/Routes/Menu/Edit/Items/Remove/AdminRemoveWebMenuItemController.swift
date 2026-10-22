import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebMenuItemController: Sendable {

    func postRemoveWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
