import FeatherWebAdmin
import UserModule

extension Identity.Detail.Repository {
    enum Role {}
}

extension Identity.Detail.Repository.Role {
    protocol Interface: Sendable {

        func names(for ids: [String]) async throws -> [String]
    }
}
