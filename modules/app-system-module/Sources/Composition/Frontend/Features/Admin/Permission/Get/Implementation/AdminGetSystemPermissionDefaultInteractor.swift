import FeatherAdmin
import Foundation

struct AdminGetSystemPermissionDefaultInteractor:
    AdminGetSystemPermissionInteractor
{
    let repository: any AdminGetSystemPermissionRepository

    func execute(
        entity: AdminGetSystemPermissionModel
    ) async throws -> SystemPermissionDetailsModel {
        do {
            return try await repository.get(id: entity.id)
        } catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw AdminGetSystemPermissionError.notFound
            case .unauthorized: throw AdminGetSystemPermissionError.unauthorized
            case .forbidden: throw AdminGetSystemPermissionError.forbidden
            case .failure, .transport, .conflict:
                throw AdminGetSystemPermissionError.unavailable
            }
        }
    }
}
