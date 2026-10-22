import FeatherWebAdmin
import OpenAPIRuntime

struct AdminEditMenuDefaultInteractor:
    AdminEditMenuInteractor
{
    let repository: any AdminEditMenuRepository

    func load(
        id: String
    ) async throws -> MenuDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: MenuFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
