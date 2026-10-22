import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminRemovePageInteractor: Sendable {

    func get(
        id: String
    ) async throws -> PageDetailsModel

    func delete(
        id: String
    ) async throws

    func delete(ids: [String]) async throws
}
