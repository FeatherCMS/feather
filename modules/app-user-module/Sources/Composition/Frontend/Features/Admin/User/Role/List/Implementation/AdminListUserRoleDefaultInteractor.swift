import FeatherAdmin
import Foundation
import UserAdminAPI

struct AdminListUserRoleDefaultInteractor: AdminListUserRoleInteractor {
    let repository: any AdminListUserRoleRepository

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> NewAdminListModel<
        Components.Schemas.UserRoleListItemSchema
    > {
        do {
            let response = try await repository.list(
                page: page,
                size: size,
                search: search
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
            case .unauthorized: throw AdminListUserRoleError.unauthorized
            case .forbidden: throw AdminListUserRoleError.forbidden
            default: throw AdminListUserRoleError.unavailable
            }
        }
    }
}
