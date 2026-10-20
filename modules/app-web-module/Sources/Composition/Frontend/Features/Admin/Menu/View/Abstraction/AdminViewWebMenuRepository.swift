import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminViewWebMenuRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebMenuDetailsModel
}
