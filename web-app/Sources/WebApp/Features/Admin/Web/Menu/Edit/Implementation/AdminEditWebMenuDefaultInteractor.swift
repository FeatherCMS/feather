import Foundation

struct AdminEditWebMenuDefaultInteractor:
    AdminEditWebMenuInteractor
{
    let repository: any AdminEditWebMenuRepository

    func load(
        id: String
    ) async throws -> WebMenuDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: WebMenuFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
