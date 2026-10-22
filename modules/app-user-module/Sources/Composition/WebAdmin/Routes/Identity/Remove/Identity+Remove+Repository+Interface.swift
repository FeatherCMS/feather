import FeatherWebAdmin
import UserModule

extension Identity.Remove.Repository {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
