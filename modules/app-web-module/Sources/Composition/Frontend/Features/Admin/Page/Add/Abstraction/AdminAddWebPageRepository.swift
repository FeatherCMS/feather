import FeatherAdmin
import OpenAPIRuntime

protocol AdminAddWebPageRepository: Sendable {

    func create(
        input: WebPageFormInput
    ) async throws
}
