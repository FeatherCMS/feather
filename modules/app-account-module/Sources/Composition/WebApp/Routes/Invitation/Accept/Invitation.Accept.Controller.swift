import AccountModule
import FeatherWebShared
import Hummingbird

extension Invitation.Accept {
    enum Controller {}
}

extension Invitation.Accept.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response

        func post(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}
