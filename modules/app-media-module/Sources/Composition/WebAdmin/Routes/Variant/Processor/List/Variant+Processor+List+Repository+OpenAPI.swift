import FeatherWebAdmin
import FeatherWebShared
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime

extension Variant.Processor.List.Repository {
    struct OpenAPI:
        Variant.Processor.List.Repository.Interface
    {
        let api: MediaAdminAPIClient

        func list(
            variantId: String,
            page: Int,
            search: String?
        ) async throws
            -> MediaAdminAPI.Components.Responses
            .MediaVariantProcessorQueryItemSearchSchemaSearchResponse
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantProcessorQuery(
                    path: .init(mediaVariantId: variantId),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            sort: [.init(field: .name, direction: .asc)],
                            filters: .init(search: search)
                        )
                    )
                )
                switch response {
                case .ok(let result): return result
                case .notFound: throw OpenAPIRepositoryError.notFound
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
