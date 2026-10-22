import AuthModule

extension Session.List.Repository {
    protocol Interface: Sendable {
        func list(
            identityID: String
        ) async throws -> Session.List.Model
    }
}
