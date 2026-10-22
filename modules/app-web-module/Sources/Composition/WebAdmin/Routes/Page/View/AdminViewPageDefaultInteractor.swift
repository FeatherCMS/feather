import FeatherWebAdmin
import OpenAPIRuntime

struct AdminViewPageDefaultInteractor: AdminViewPageInteractor {
    let repository: any AdminViewPageRepository

    func execute(
        entity: AdminViewPageModel
    ) async throws -> PageDetailsModel {
        try await repository.get(id: entity.id)
    }
}
