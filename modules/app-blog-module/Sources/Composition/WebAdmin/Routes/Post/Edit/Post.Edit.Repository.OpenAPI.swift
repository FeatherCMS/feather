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

extension Post.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            id: String
        ) async throws -> Post.View.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogPostGet(
                    path: .init(blogPostId: id),
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
                            api: api.mediaAdminAPI()
                        ).loadImageAsset(assetId: page.imageAssetId),
                        metadata: WebModule.Metadata.SchemaBuilder.formValue(
                            from: page.metadata,
                            fallbackTitle: page.title,
                            fallbackExcerpt: page.excerpt
                        ),
                        authorIds: Array(page.authorIds),
                        tagIds: Array(page.tagIds)
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
            input: Post.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogPostPatch(
                    path: .init(blogPostId: id),
                    query: .init(updateMask: "title,excerpt,content,imageAssetId,authorIds,tagIds"),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            title: input.normalizedTitle,
                            excerpt: input.normalizedExcerpt,
                            content: input.normalizedContent,
                            imageAssetId: input.normalizedImageAssetId,
                            authorIds: input.normalizedAuthorIds,
                            tagIds: input.normalizedTagIds,
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
