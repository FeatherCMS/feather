import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Remove {
    enum Interactor {}
}

extension WebModule.Menu.Remove.Interactor {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> WebModule.Menu.View.Model

        func delete(
            id: String
        ) async throws

        func delete(ids: [String]) async throws
    }
}
