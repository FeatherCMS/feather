import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminViewPageRepository: Sendable {

    func get(
        id: String
    ) async throws -> PageDetailsModel
}
