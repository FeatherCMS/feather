import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminEditWebMetadataDefaultInteractor:
    AdminEditWebMetadataInteractor
{
    let repository: any AdminEditWebMetadataRepository

    func load(
        id: String
    ) async throws -> WebMetadataDetailsModel {
        try await repository.load(id: id)
    }

    func load(
        referenceType: String,
        referenceID: String
    ) async throws -> WebMetadataDetailsModel {
        try await repository.load(
            referenceType: referenceType,
            referenceID: referenceID
        )
    }

    func update(
        id: String,
        input: WebMetadataFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
