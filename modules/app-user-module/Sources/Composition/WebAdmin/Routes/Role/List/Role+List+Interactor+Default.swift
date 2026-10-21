import FeatherWebAdmin
import FeatherWebShared
import UserAdminAPI
import UserModule

extension Role.List.Interactor {
    struct Default: Interface {
        let repository: any Role.List.Repository.Interface

        func list(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> AdminListModel<
            Components.Schemas.UserRoleQueryItemSchema
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
                case .unauthorized: throw Role.List.Error.unauthorized
                case .forbidden: throw Role.List.Error.forbidden
                default: throw Role.List.Error.unavailable
                }
            }
        }
    }
}
