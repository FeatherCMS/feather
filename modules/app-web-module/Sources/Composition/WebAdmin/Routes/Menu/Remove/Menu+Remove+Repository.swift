import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

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
