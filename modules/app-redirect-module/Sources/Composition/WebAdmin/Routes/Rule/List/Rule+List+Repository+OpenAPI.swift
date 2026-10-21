import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.List.Repository {
    struct OpenAPI: Interface {
    let api: API.Client
    init(api: API.Client) {
        self.api = api
    }

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: RedirectModule.Rule.StatusCode?
    ) async throws
        -> RedirectAdminAPI.Components.Responses
        .RedirectRuleQueryItemSearchSchemaSearchResponse
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .redirectRuleQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(
                                size: RedirectModule.Rule.List.Router.pageSize,
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
}
