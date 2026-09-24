import FeatherAdmin
import MediaAdminAPI
import OpenAPIRuntime

struct AdminRemoveMediaVariantOpenAPIRepository:
    AdminRemoveMediaVariantRepository
{
    let api: MediaAdminAPIClient

    func names(ids: [String]) async throws -> [NewAdminRemoveItemContext] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            var items: [NewAdminRemoveItemContext] = []
            for id in ids {
                let response = try await client.mediaVariantGet(
                    path: .init(mediaVariantId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let result):
                    let variant = try result.body.json
                    items.append(
                        NewAdminRemoveItemContext(
                            id: id,
                            label: "\(variant.name) (\(variant.key))"
                        )
                    )
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
            return items
        }
    }

    func delete(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantRemove(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(ids: ids, results: false, summary: true))
            )
            switch response {
            case .ok: return
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
