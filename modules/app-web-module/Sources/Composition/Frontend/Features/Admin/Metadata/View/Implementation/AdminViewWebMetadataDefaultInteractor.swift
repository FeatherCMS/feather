import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminViewWebMetadataDefaultInteractor: AdminViewWebMetadataInteractor {
    let repository: any AdminViewWebMetadataRepository

    func execute(
        entity: AdminViewWebMetadataModel
    ) async throws -> WebMetadataDetailsModel {
        try await repository.get(id: entity.id)
    }
}
