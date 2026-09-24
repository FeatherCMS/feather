import FeatherAdmin
import OpenAPIRuntime

protocol AdminViewWebPageRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebPageDetailsModel
}
