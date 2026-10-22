import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Logout.Controller {
    protocol Interface: Sendable {

        func getLogout(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}
