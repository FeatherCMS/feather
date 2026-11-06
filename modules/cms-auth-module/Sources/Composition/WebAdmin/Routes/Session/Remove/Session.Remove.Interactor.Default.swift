import AuthModule
import FeatherWebAdmin

extension Session.Remove.Interactor {
    struct Default: Interface {
        private let repository: any Session.Remove.Repository.Interface

        init(repository: any Session.Remove.Repository.Interface) {
            self.repository = repository
        }

        func get(
            identityId: String,
            sessionId: String
        ) async throws -> Session.Remove.Model {
            try await repository.get(
                identityId: identityId,
                sessionId: sessionId
            )
        }

        func execute(
            entity: Session.Remove.Model
        ) async throws {
            try await repository.delete(
                identityId: entity.identityId,
                sessionId: entity.sessionId
            )
        }
    }
}
