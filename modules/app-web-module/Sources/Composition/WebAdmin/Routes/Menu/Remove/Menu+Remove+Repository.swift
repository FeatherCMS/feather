import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain

extension Menu.Remove {
    enum Repository {}
}

extension Menu.Remove.Repository {
    protocol Interface: Sendable {

    func get(
        id: String
    ) async throws -> MenuDetailsModel

    func delete(
        id: String
    ) async throws
    }
}
