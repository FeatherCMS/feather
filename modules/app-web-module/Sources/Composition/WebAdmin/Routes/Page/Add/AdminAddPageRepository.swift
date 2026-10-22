import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminAddPageRepository: Sendable {

    func create(
        input: PageFormInput
    ) async throws
}
