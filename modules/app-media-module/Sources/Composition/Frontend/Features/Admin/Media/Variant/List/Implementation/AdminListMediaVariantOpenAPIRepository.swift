import FeatherAdmin
import MediaAdminAPI
import OpenAPIRuntime

struct AdminListMediaVariantOpenAPIRepository: AdminListMediaVariantRepository {
    let api: MediaAdminAPIClient

    func listMediaVariants(
        page: Int,
        search: String?
    ) async throws
        -> MediaAdminAPI.Components.Responses
        .MediaVariantListItemSearchSchemaSearchResponse
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantList(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(
                            size: AdminListMediaVariant.pageSize,
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
