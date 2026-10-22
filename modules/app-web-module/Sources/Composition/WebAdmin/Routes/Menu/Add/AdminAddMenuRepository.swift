import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminAddMenuRepository: Sendable {

    func create(
        input: MenuFormInput
    ) async throws
}
