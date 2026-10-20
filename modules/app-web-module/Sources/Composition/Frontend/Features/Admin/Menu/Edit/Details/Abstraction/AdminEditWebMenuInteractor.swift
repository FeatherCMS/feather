import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminEditWebMenuInteractor: Sendable {

    func load(
        id: String
    ) async throws -> WebMenuDetailsModel

    func update(
        id: String,
        input: WebMenuFormInput
    ) async throws
}
