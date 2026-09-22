import FeatherAdmin
import OpenAPIRuntime

protocol AdminAddWebMenuRepository: Sendable {

    func create(
        input: WebMenuFormInput
    ) async throws
}
