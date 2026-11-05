import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Login {
    enum Controller {}
}

extension Login.Controller {
    protocol Interface: Sendable {

        func getLogin(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse

        func postLogin(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}
