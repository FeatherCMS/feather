import UserModule

extension Role.Detail.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Role.Detail.RepositoryModel
    }
}
