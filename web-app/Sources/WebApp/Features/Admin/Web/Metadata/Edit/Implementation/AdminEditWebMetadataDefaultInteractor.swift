import Foundation

struct AdminEditWebMetadataDefaultInteractor:
    AdminEditWebMetadataInteractor
{
    let repository: any AdminEditWebMetadataRepository

    func load(
        id: String
    ) async throws -> WebMetadataDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: WebMetadataFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
