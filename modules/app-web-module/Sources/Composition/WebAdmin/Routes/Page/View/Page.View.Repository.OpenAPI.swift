import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import MediaModule
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension Page.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        let mediaAPI: MediaWebAdmin.API.Client

        func get(
            id: String
        ) async throws -> Page.Details.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .pageGet(
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
                        imageAsset: try await Asset.File.View.Repository.OpenAPI(
                            api: mediaAPI
                        ).loadImageAsset(assetId: page.imageAssetId)
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

    }
}
