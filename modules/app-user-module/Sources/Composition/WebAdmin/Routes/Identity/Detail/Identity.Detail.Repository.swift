import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Identity.Detail {
    enum Repository {}
}

extension Identity.Detail.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Model
    }
}
