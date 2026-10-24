import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Remove {
    enum Interactor {}
}

extension Page.Remove.Interactor {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> Page.Details.Model

        func delete(
            id: String
        ) async throws

        func delete(ids: [String]) async throws
    }
}
