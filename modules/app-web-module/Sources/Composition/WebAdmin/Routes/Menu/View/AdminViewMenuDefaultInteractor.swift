import FeatherWebAdmin
import OpenAPIRuntime

struct AdminViewMenuDefaultInteractor: AdminViewMenuInteractor {
    let repository: any AdminViewMenuRepository

    func execute(
        entity: AdminViewMenuModel
    ) async throws -> MenuDetailsModel {
        try await repository.get(id: entity.id)
    }
}
