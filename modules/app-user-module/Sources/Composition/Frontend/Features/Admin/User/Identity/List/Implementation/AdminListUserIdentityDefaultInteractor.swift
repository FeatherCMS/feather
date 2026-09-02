import FeatherAdmin
import Foundation
import UserAdminAPI

struct AdminListUserIdentityDefaultInteractor: AdminListUserIdentityInteractor {
    let repository: any AdminListUserIdentityRepository

    func execute(
        page: Int,
        size: Int,
        search: String?,
        role: String?
    ) async throws -> (
        items: [Components.Schemas.UserIdentityListItemSchema], total: Int,
        page: Int, size: Int
    ) {
        try await repository.list(
            page: page,
            size: size,
            search: search,
            role: role
        )
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
