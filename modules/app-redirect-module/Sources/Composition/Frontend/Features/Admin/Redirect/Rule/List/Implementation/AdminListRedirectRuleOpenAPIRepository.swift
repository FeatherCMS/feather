import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird
import OpenAPIRuntime
import RedirectAdminAPI
import RedirectContracts

struct AdminListRedirectRuleOpenAPIRepository:
    AdminListRedirectRuleRepository
{
    let api: RedirectAdminAPIClient
    init(api: RedirectAdminAPIClient) {
        self.api = api
    }

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: StatusCode?
    ) async throws
        -> RedirectAdminAPI.Components.Responses
        .RedirectRuleListItemSearchSchemaSearchResponse
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .redirectRuleSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(
                                size: AdminListRedirectRule.pageSize,
                                number: page
                            ),
                            filters: .init(
                                search: search,
                                statusCode: statusCode?.rawValue
                            )
                        )
                    )
                )

            switch response {
            case .ok(let okResponse):
                return okResponse
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
