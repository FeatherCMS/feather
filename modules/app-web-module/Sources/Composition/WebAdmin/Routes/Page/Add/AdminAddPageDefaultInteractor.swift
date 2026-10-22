import FeatherWebAdmin
import OpenAPIRuntime

struct AdminAddPageDefaultInteractor: AdminAddPageInteractor {
    let repository: any AdminAddPageRepository

    func execute(
        input: PageFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
