import FeatherAdmin
import Foundation
import UserAdminAPI

struct AdminListUserIdentityDefaultInteractor: AdminListUserIdentityInteractor {
    let repository: any AdminListUserIdentityRepository

    func list(
        page: Int,
        size: Int,
        search: String?,
        role: String?
    ) async throws -> NewAdminListModel<
        Components.Schemas.UserIdentityListItemSchema
    > {
        do {
            let response = try await repository.list(
                page: page,
                size: size,
                search: search,
                role: role
            )
            let body = try response.body.json
            return .init(
                items: body.data.items,
                pageState: .init(
                    page: body.query.page.number,
                    pageSize: body.query.page.size,
                    total: body.data.total
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized: throw AdminListUserIdentityError.unauthorized
            case .forbidden: throw AdminListUserIdentityError.forbidden
            default: throw AdminListUserIdentityError.unavailable
            }
        }
    }
}
