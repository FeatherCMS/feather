import UserModule

extension Role.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
