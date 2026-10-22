import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Remove {
    enum Interactor {}
}

extension Menu.Remove.Interactor {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> MenuDetailsModel

        func delete(
            id: String
        ) async throws

        func delete(ids: [String]) async throws
    }
}
