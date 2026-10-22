import FeatherWebAdmin
import OpenAPIRuntime

struct AdminEditPageDefaultInteractor:
    AdminEditPageInteractor
{
    let repository: any AdminEditPageRepository

    func load(
        id: String
    ) async throws -> PageEditDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: PageFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
