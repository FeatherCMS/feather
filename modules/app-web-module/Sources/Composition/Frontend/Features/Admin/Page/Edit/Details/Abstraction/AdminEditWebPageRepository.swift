import FeatherAdmin
import OpenAPIRuntime

protocol AdminEditWebPageRepository: Sendable {

    func load(
        id: String
    ) async throws -> WebPageEditDetailsModel

    func update(
        id: String,
        input: WebPageFormInput
    ) async throws
}
