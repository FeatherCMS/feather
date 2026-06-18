import Foundation

struct AdminGetWebMetadataDefaultInteractor: AdminGetWebMetadataInteractor {
    let repository: any AdminGetWebMetadataRepository

    func execute(
        entity: AdminGetWebMetadataModel
    ) async throws -> WebMetadataDetailsModel {
        try await repository.get(id: entity.id)
    }
}
