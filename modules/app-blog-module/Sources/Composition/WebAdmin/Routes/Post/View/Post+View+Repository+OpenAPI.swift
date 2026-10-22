import BlogAdminAPI
import BlogModule
import BlogWebShared
import FeatherWebAdmin
import FeatherWebShared
import MediaWebAdmin
import OpenAPIRuntime
import WebModuleWebAdmin

extension Post.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(id: String) async throws -> Post.View.Details.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .blogPostGet(
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
                        imageAsset: try await api.mediaAdminAPI()
                            .loadImageAsset(assetId: page.imageAssetId),
                        metadata: AdminMetadataSchemaBuilder.formValue(
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
    }
}
