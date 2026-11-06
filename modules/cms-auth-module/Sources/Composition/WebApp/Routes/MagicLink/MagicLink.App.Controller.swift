import AuthModule
import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension MagicLink.App {
    enum Controller {}
}

extension MagicLink.App.Controller {
    protocol Interface: Sendable {
        func getRequest(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse

        func postRequest(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response

        func verify(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}
