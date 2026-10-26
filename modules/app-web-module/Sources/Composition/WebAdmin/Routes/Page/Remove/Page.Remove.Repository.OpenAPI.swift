import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule
import MediaWebAdmin
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension Page.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            id: String
        ) async throws -> Page.Details.Model {
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
                        imageAsset: try await Asset.File.View.Repository
                            .OpenAPI(
                                api: api.mediaAdminAPI()
                            )
                            .loadImageAsset(assetId: page.imageAssetId),
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

        func delete(
            id: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.pageRemove(
                    body: .json(.init(ids: [id]))
                )
            }
        }

    }
}
