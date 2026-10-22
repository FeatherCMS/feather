import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminRemovePageRepository: Sendable {

    func get(
        id: String
    ) async throws -> PageDetailsModel

    func delete(
        id: String
    ) async throws
}
