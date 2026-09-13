import FeatherAdmin
import Foundation

struct AdminGetUserRoleDefaultInteractor: AdminGetUserRoleInteractor {
    let repository: any AdminGetUserRoleRepository

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw AdminGetUserRoleError.notFound
            case .unauthorized: throw AdminGetUserRoleError.unauthorized
            case .forbidden: throw AdminGetUserRoleError.forbidden
            default: throw AdminGetUserRoleError.unavailable
            }
        }
    }
}
