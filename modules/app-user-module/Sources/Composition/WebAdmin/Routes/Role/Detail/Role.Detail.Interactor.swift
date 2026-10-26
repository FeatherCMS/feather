import UserModule

extension Role.Detail {
    enum Interactor {}
}

extension Role.Detail.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Role.Detail.Repository.Model
    }
}
