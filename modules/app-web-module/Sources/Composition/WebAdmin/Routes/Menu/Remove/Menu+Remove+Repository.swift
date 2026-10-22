import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain

extension WebDomain.Menu.Remove {
    enum Repository {}
}

extension WebDomain.Menu.Remove.Repository {
    protocol Interface: Sendable {

    func get(
        id: String
    ) async throws -> MenuDetailsModel

    func delete(
        id: String
    ) async throws
    }
}
