import FeatherWebAdmin
import OpenAPIRuntime

struct AdminAddMenuDefaultInteractor: AdminAddMenuInteractor {
    let repository: any AdminAddMenuRepository

    func execute(
        input: MenuFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
