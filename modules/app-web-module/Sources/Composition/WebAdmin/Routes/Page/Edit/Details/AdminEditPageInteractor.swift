import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminEditPageInteractor: Sendable {

    func load(
        id: String
    ) async throws -> PageEditDetailsModel

    func update(
        id: String,
        input: PageFormInput
    ) async throws
}
