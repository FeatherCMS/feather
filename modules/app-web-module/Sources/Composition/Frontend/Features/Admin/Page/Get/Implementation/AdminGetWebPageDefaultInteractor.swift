import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminGetWebPageDefaultInteractor: AdminGetWebPageInteractor {
    let repository: any AdminGetWebPageRepository

    func execute(
        entity: AdminGetWebPageModel
    ) async throws -> WebPageDetailsModel {
        try await repository.get(id: entity.id)
    }
}
