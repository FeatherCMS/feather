import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime

extension Variant.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(id: String) async throws
            -> Variant.Edit.Model
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantGet(
                    path: .init(mediaVariantId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let result):
                    let detail = try result.body.json
                    return Variant.Edit.Model(
                        id: detail.id,
                        key: detail.key,
                        name: detail.name,
                        isRequired: detail.isRequired,
                        isActive: detail.isActive
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
        }

        func loadProcessor(variantId: String, id: String) async throws
            -> Variant.Processor.Edit.Model
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
                case .ok(let result):
                    let detail = try result.body.json
                    return Variant.Processor.Edit.Model(
                        id: detail.id,
                        variantId: variantId,
                        name: detail.name,
                        matchExtensions: detail.matchExtensions,
                        commandTemplate: detail.commandTemplate,
                        isActive: detail.isActive
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
        }

        func processorNames(variantId: String, ids: [String]) async throws
            -> [AdminRemoveItemContext]
        {
            var items: [AdminRemoveItemContext] = []
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
            input: MediaAdminAPI.Components.Schemas.MediaVariantPatchSchema
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantPatch(
                    path: .init(mediaVariantId: id),
                    query: .init(updateMask: "key,name,isRequired,isActive"),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(input)
                )
                switch response {
                case .ok: return
                case .badRequest(let response):
                    let data = try JSONEncoder().encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
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
        }

        func addProcessor(
            variantId: String,
            input: MediaAdminAPI.Components.Schemas
                .MediaVariantProcessorCreateSchema
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantProcessorPost(
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
                .MediaVariantProcessorPatchSchema
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantProcessorPatch(
                    path: .init(
                        mediaVariantId: variantId,
                        mediaVariantProcessorId: id
                    ),
                    query: .init(
                        updateMask:
                            "name,matchExtensions,commandTemplate,isActive"
                    ),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(input)
                )
                switch response {
                case .ok: return
                case .badRequest(let response):
                    let data = try JSONEncoder().encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
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
        }

        func removeProcessor(variantId: String, id: String) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantProcessorDelete(
                    path: .init(mediaVariantId: variantId),
                    body: .json(.init(ids: [id]))
                )
                switch response {
                case .noContent: return
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
