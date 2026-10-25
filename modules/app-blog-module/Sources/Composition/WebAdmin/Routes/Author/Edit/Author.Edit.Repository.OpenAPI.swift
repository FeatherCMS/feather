import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension Author.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            id: String
        ) async throws -> Author.View.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogAuthorGet(
                    path: .init(blogAuthorId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let okResponse):
                    let menu = try okResponse.body.json
                    return .init(
                        id: menu.id,
                        name: menu.name,
                        excerpt: menu.excerpt,
                        content: menu.content,
                        profileImageAssetId: menu.profileImageAssetId,
                        profileImage: try await Asset.File.View.Repository.OpenAPI(
                            api: api.mediaAdminAPI()
                        ).loadImageAsset(assetId: menu.profileImageAssetId),
                        metadata: WebModule.Metadata.SchemaBuilder.formValue(
                            from: menu.metadata,
                            fallbackTitle: menu.name,
                            fallbackExcerpt: menu.excerpt
                        ),
                        items: []
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
            input: Author.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogAuthorPatch(
                    path: .init(blogAuthorId: id),
                    query: .init(updateMask: "name,excerpt,content,profileImageAssetId"),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            name: input.normalizedName,
                            excerpt: input.normalizedExcerpt,
                            content: input.normalizedContent,
                            profileImageAssetId: input
                                .normalizedProfileImageAssetId,
                        )
                    )
                )
                switch response {
                case .ok:
                    return
                case .badRequest(let response):
                    let data = try JSONEncoder().encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
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
