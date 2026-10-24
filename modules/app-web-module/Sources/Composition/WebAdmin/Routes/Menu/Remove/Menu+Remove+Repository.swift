import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Remove {
    enum Repository {}
}

extension WebModule.Menu.Remove.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> WebModule.Menu.View.Model

        func delete(
            id: String
        ) async throws
    }
}
