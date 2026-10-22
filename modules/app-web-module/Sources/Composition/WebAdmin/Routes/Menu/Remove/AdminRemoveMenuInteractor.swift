import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminRemoveMenuInteractor: Sendable {

    func get(
        id: String
    ) async throws -> MenuDetailsModel

    func delete(
        id: String
    ) async throws

    func delete(ids: [String]) async throws
}
