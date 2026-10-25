import AuthModule

extension Session.List {
    enum Repository {}
}

extension Session.List.Repository {
    protocol Interface: Sendable {
        func search(
            identityID: String
        ) async throws -> Session.List.Model
    }
}
