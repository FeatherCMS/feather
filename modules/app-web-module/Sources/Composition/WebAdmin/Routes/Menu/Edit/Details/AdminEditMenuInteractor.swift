import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminEditMenuInteractor: Sendable {

    func load(
        id: String
    ) async throws -> MenuDetailsModel

    func update(
        id: String,
        input: MenuFormInput
    ) async throws
}
