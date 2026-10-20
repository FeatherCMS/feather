import FeatherWebAdmin
import FeatherModuleKit
import SystemAdminAPI
import SystemModule

extension Job.List.Interactor {
    struct Default: Interface {
        let repository: any Job.List.Repository.Interface

        func list(
            page: Int,
            search: String?,
            status: Int?
        ) async throws -> Job.List.Model {
            let result: Components.Schemas.SystemJobSearchSchema
            do {
                result = try await repository.search(
                    page: page,
                    search: search,
                    status: status
                )
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized:
                    throw Job.List.Error
                        .unauthorized
                case .forbidden:
                    throw Job.List.Error.forbidden
                case .failure, .transport, .notFound, .conflict:
                    throw Job.List.Error
                        .unavailable
                }
            }
            let pageSize = Job.List.Router.pageSize
            let normalizedPage = max(1, page)
            let items = result.data.items
            return .init(
                items: items,
                pageState: .init(
                    page: normalizedPage,
                    pageSize: pageSize,
                    total: result.data.total
                )
            )
        }
    }
}
