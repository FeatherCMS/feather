import Foundation

struct AdminEditWebPageDefaultInteractor:
    AdminEditWebPageInteractor
{
    let repository: any AdminEditWebPageRepository

    func load(
        id: String
    ) async throws -> WebPageDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: WebPageFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
