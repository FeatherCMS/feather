import UserModule

extension Role.Detail {
    enum Repository {}
}

extension Role.Detail.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Model
    }
}
