import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain

extension WebDomain.Menu.Remove {
    enum Interactor {}
}

extension WebDomain.Menu.Remove.Interactor {
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
