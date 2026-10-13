import FeatherAdmin
import RedirectAdminAPI
import RedirectContracts

struct AdminListRedirectRuleDefaultInteractor:
    AdminListRedirectRuleInteractor
{
    let repository: any AdminListRedirectRuleRepository

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: StatusCode?
    ) async throws -> NewAdminListModel<
        Components.Schemas.RedirectRuleListItemSchema
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
    ) -> AdminListRedirectRuleError {
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
