import FeatherWebAdmin
import UserModule

extension Identity.Detail {
    enum Interactor {}
}

extension Identity.Detail.Interactor {
    protocol Interface: Sendable {
        func roleNames(for ids: [String]) async throws -> [String]

        func load(
            id: String
        ) async throws -> Identity.Detail.Repository.Model
    }
}
