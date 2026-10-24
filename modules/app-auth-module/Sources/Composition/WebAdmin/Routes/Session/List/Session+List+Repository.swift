import AuthModule

extension Session.List {
    enum Repository {}
}

extension Session.List.Repository {
    protocol Interface: Sendable {
        func list(
            identityID: String
        ) async throws -> Session.List.Model
    }
}
