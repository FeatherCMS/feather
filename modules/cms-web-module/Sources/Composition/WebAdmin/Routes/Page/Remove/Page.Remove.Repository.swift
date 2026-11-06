import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Remove {
    enum Repository {}
}

extension Page.Remove.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> Page.Details.Model

        func delete(
            id: String
        ) async throws
    }
}
