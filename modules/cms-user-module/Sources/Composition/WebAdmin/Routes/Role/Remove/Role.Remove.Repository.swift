import UserModule

extension Role.Remove {
    enum Repository {}
}

extension Role.Remove.Repository {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
