import FeatherAdmin
import Foundation

struct AdminViewSystemPermissionDefaultInteractor:
    AdminViewSystemPermissionInteractor
{
    let repository: any AdminViewSystemPermissionRepository

    func execute(
        entity: AdminViewSystemPermissionModel
    ) async throws -> SystemPermissionDetailsModel {
        do {
            return try await repository.get(id: entity.id)
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw AdminViewSystemPermissionError.notFound
            case .unauthorized: throw AdminViewSystemPermissionError.unauthorized
            case .forbidden: throw AdminViewSystemPermissionError.forbidden
            case .failure, .transport, .conflict:
                throw AdminViewSystemPermissionError.unavailable
            }
        }
    }
}
