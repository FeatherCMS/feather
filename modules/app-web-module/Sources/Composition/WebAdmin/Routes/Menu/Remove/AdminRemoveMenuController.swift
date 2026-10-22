import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveMenuController: Sendable {

    func postRemoveMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
