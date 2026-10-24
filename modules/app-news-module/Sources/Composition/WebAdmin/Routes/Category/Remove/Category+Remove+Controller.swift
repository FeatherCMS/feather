import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Remove {
    enum Controller {}
}

extension Category.Remove.Controller {
    protocol Interface: Sendable {
        func getRemoveNewsCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response

        func postRemoveNewsCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
