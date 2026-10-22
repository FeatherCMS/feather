import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminEditPageRepository: Sendable {

    func load(
        id: String
    ) async throws -> PageEditDetailsModel

    func update(
        id: String,
        input: PageFormInput
    ) async throws
}
