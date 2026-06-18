import AdminOpenAPI
import Foundation

struct AdminListUserRoleDefaultInteractor: AdminListUserRoleInteractor {
    let repository: any AdminListUserRoleRepository

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserRoleListItemSchema], total: Int,
        page: Int, size: Int
    ) {
        try await repository.list(
            page: page,
            size: size,
            search: search
        )
    }

    func bulkRemove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
