import UserModule

extension Role.Remove {
    enum Interactor {}
}

extension Role.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
