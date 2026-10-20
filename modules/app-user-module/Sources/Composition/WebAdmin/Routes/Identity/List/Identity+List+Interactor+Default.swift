import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Identity.List.Interactor {
    struct Default: Interface {
        let repository: any Identity.List.Repository.Interface

        func list(
            page: Int,
            size: Int,
            search: String?,
            role: String?
        ) async throws -> AdminListModel<
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
                case .unauthorized: throw Identity.List.Error.unauthorized
                case .forbidden: throw Identity.List.Error.forbidden
                default: throw Identity.List.Error.unavailable
                }
            }
        }
    }
}
