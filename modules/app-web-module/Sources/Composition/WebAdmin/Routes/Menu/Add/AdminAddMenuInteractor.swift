import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminAddMenuInteractor: Sendable {

    func execute(
        input: MenuFormInput
    ) async throws
}
