import FeatherAdmin
import OpenAPIRuntime

struct AdminViewWebPageDefaultInteractor: AdminViewWebPageInteractor {
    let repository: any AdminViewWebPageRepository

    func execute(
        entity: AdminViewWebPageModel
    ) async throws -> WebPageDetailsModel {
        try await repository.get(id: entity.id)
    }
}
