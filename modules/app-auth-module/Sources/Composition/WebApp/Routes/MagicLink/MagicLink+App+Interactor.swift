import AuthModule
import FeatherWebShared

extension MagicLink.App.Interactor {
    protocol Interface: Sendable {
        func request(
            email: String,
            isPersistent: Bool,
            context: DefaultRequestContext
        ) async throws

        func verify(
            token: String,
            context: DefaultRequestContext
        ) async throws -> MagicLink.App.Result
    }
}
