import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemovePageController: Sendable {

    func postRemovePage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
