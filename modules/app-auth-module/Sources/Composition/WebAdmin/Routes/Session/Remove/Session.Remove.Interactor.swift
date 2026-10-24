import AuthModule
import FeatherWebAdmin

extension Session.Remove {
    enum Interactor {}
}

extension Session.Remove.Interactor {
    protocol Interface: Sendable {

        func get(
            identityId: String,
            sessionId: String
        ) async throws -> Session.Remove.Model

        func execute(
            entity: Session.Remove.Model
        ) async throws
    }
}
