import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminRemoveMenuRepository: Sendable {

    func get(
        id: String
    ) async throws -> MenuDetailsModel

    func delete(
        id: String
    ) async throws
}
