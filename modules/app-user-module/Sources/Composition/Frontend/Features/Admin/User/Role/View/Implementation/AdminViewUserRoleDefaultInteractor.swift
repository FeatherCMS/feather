import FeatherAdmin
import Foundation

struct AdminViewUserRoleDefaultInteractor: AdminViewUserRoleInteractor {
    let repository: any AdminViewUserRoleRepository

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw AdminViewUserRoleError.notFound
            case .unauthorized: throw AdminViewUserRoleError.unauthorized
            case .forbidden: throw AdminViewUserRoleError.forbidden
            default: throw AdminViewUserRoleError.unavailable
            }
        }
    }
}
