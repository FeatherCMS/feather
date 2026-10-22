import FeatherWebAdmin
import FeatherWebShared
import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension Rule.List.Interactor {
    struct Default: Interface {
        let repository: any Rule.List.Repository.Interface

        func listRedirectRules(
            page: Int,
            search: String?,
            statusCode: Rule.StatusCode?
        ) async throws -> AdminListModel<
            Components.Schemas.RedirectRuleQueryItemSchema
        > {
            do {
                let response = try await repository.listRedirectRules(
                    page: page,
                    search: search,
                    statusCode: statusCode
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
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> Rule.List.Error {
            switch error {
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .notFound, .conflict, .failure, .transport:
                .unavailable
            }
        }

    }
}
