import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminAddWebMenuRepository: Sendable {

    func create(
        input: WebMenuFormInput
    ) async throws
}
