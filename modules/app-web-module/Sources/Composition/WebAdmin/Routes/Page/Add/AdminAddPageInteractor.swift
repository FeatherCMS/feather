import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminAddPageInteractor: Sendable {

    func execute(
        input: PageFormInput
    ) async throws
}
