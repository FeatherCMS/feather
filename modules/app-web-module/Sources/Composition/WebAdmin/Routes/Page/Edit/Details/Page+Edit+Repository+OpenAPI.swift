import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension Page.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        let mediaAPI: MediaWebAdmin.API.Client

        func load(
            id: String
        ) async throws -> Page.Edit.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.pageGet(
                    path: .init(pageId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let okResponse):
                    let page = try okResponse.body.json
                    return .init(
                        id: page.id,
                        title: page.title,
                        excerpt: page.excerpt,
                        content: page.content,
                        imageAsset: try await mediaAPI.loadImageAsset(
                            assetId: page.imageAssetId,
                            variants: ["cover", "preview"]
                        ),
                        metadata: WebModule.Metadata.SchemaBuilder.formValue(
                            from: page.metadata,
                            fallbackTitle: page.title,
                            fallbackExcerpt: page.excerpt
                        )
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
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

        func update(
            id: String,
            input: Page.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.pageUpdate(
                    path: .init(pageId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            title: input.normalizedTitle,
                            excerpt: input.normalizedExcerpt,
                            content: input.normalizedContent,
                            imageAssetId: input.normalizedImageAssetIdForUpdate,
                        )
                    )
                )
                switch response {
                case .ok:
                    return
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
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
