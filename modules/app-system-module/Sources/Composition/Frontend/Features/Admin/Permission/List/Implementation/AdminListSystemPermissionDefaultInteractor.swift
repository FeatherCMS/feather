import FeatherAdmin
import Hummingbird
import SystemContracts

struct AdminListSystemPermissionDefaultInteractor:
    AdminListSystemPermissionInteractor
{
    let repository: any AdminListSystemPermissionRepository

    func listSystemPermissions(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemPermissionModel {
        do {
            return try await repository.listSystemPermissions(
                page: page,
                search: search
            )
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized:
                throw AdminListSystemPermissionError.unauthorized
            case .forbidden: throw AdminListSystemPermissionError.forbidden
            case .failure, .transport, .notFound, .conflict:
                throw AdminListSystemPermissionError.unavailable
            }
        }
    }

}
