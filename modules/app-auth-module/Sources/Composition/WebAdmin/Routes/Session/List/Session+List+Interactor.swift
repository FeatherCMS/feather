import AuthModule

extension Session.List.Interactor {
    protocol Interface: Sendable {
        func list(
            identityID: String
        ) async throws -> Session.List.Model
    }
}
