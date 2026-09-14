import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminViewWebMenuDefaultInteractor: AdminViewWebMenuInteractor {
    let repository: any AdminViewWebMenuRepository

    func execute(
        entity: AdminViewWebMenuModel
    ) async throws -> WebMenuDetailsModel {
        try await repository.get(id: entity.id)
    }
}
