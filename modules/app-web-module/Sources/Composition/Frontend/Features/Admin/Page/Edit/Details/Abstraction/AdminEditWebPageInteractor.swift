import FeatherAdmin
import OpenAPIRuntime

protocol AdminEditWebPageInteractor: Sendable {

    func load(
        id: String
    ) async throws -> WebPageEditDetailsModel

    func update(
        id: String,
        input: WebPageFormInput
    ) async throws
}
