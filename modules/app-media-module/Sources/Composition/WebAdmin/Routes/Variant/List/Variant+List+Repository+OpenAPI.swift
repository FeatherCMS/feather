import FeatherWebAdmin
import FeatherWebShared
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime

extension Variant.List.Repository {
    struct OpenAPI: Variant.List.Repository.Interface {
        let api: API.Client

        func listMediaVariants(
            page: Int,
            search: String?
        ) async throws
            -> MediaAdminAPI.Components.Responses
            .MediaVariantQueryItemSearchSchemaSearchResponse
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(
                                size: Variant.List.Router.pageSize,
                                number: page
                            ),
                            sort: [.init(field: .name, direction: .asc)],
                            filters: .init(search: search)
                        )
                    )
                )
                switch response {
                case .ok(let result): return result
                case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                case .forbidden: throw OpenAPIRepositoryError.forbidden
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
