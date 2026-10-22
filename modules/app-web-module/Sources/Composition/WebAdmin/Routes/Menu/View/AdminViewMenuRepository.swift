import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminViewMenuRepository: Sendable {

    func get(
        id: String
    ) async throws -> MenuDetailsModel
}
