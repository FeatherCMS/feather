import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension Variable.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func listSystemVariables(
            page: Int,
            search: String?,
            ids: [String]? = nil
        ) async throws
            -> SystemAdminAPI.Components.Responses
            .SystemVariableQueryItemSearchSchemaSearchResponse
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .systemVariableQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                page: .init(
                                    size: max(
                                        Variable
                                            .List.Router
                                            .pageSize,
                                        ids?.count ?? 0
                                    ),
                                    number: page
                                ),
                                filters: .init(search: search, ids: ids)
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
