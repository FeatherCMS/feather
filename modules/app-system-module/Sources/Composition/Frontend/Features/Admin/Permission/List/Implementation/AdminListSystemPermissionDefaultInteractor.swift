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
        try await repository.listSystemPermissions(page: page, search: search)
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
