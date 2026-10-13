import FeatherAdmin
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime

struct AdminEditMediaVariantOpenAPIRepository: AdminEditMediaVariantRepository {
    let api: MediaAdminAPIClient

    func load(id: String) async throws
        -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantGet(
                path: .init(mediaVariantId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let result): return try result.body.json
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

    func loadProcessor(variantId: String, id: String) async throws
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantProcessorGet(
                path: .init(
                    mediaVariantId: variantId,
                    mediaVariantProcessorId: id
                ),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let result): return try result.body.json
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

    func processorNames(variantId: String, ids: [String]) async throws
        -> [NewAdminRemoveItemContext]
    {
        var items: [NewAdminRemoveItemContext] = []
        for id in ids {
            let processor = try await loadProcessor(
                variantId: variantId,
                id: id
            )
            items.append(.init(id: id, label: "\(processor.name) (\(id))"))
        }
        return items
    }

    func update(
        id: String,
        input: MediaAdminAPI.Components.Schemas.MediaVariantCreateSchema
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantUpdate(
                path: .init(mediaVariantId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(input)
            )
            switch response {
            case .ok: return
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

    func addProcessor(
        variantId: String,
        input: MediaAdminAPI.Components.Schemas
            .MediaVariantProcessorCreateSchema
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantProcessorCreate(
                path: .init(mediaVariantId: variantId),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(input)
            )
            switch response {
            case .created: return
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

    func updateProcessor(
        variantId: String,
        id: String,
        input: MediaAdminAPI.Components.Schemas
            .MediaVariantProcessorCreateSchema
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantProcessorUpdate(
                path: .init(
                    mediaVariantId: variantId,
                    mediaVariantProcessorId: id
                ),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(input)
            )
            switch response {
            case .ok: return
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

    func removeProcessor(variantId: String, id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantProcessorRemove(
                path: .init(mediaVariantId: variantId),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(ids: [id], results: false, summary: true))
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
