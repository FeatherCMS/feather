import FeatherAdmin
import OpenAPIRuntime

protocol AdminRemoveWebMenuRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebMenuDetailsModel

    func delete(
        id: String
    ) async throws
}
