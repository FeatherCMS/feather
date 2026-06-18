import Foundation

struct AdminGetWebMenuDefaultInteractor: AdminGetWebMenuInteractor {
    let repository: any AdminGetWebMenuRepository

    func execute(
        entity: AdminGetWebMenuModel
    ) async throws -> WebMenuDetailsModel {
        try await repository.get(id: entity.id)
    }
}
