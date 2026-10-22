import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminEditMenuRepository: Sendable {

    func load(
        id: String
    ) async throws -> MenuDetailsModel

    func update(
        id: String,
        input: MenuFormInput
    ) async throws
}
