import AuthModule
import FeatherWebAdmin

extension Session.Remove.Repository {
    protocol Interface: Sendable {

        func get(
            identityId: String,
            sessionId: String
        ) async throws -> Session.Remove.Model

        func delete(
            identityId: String,
            sessionId: String
        ) async throws
    }
}
