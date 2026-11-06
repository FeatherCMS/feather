import AuthModule
import FeatherWebShared

extension MagicLink.App.Interactor {
    struct Default: Interface {
        let repository: any MagicLink.App.Repository.Interface

        func request(
            email: String,
            isPersistent: Bool,
            context: DefaultRequestContext
        ) async throws {
            try await repository.request(
                email: email,
                isPersistent: isPersistent,
                context: context
            )
        }

        func verify(
            token: String,
            context: DefaultRequestContext
        ) async throws -> MagicLink.App.Result {
            try await repository.verify(token: token, context: context)
        }
    }
}
