import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddBlogTagOpenAPIRepository: AdminAddBlogTagRepository {
    let api: AdminAPI

    func create(
        input: BlogTagFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogTagCreate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        title: input.normalizedTitle,
                        excerpt: input.normalizedExcerpt,
                        content: input.normalizedContent,
                        imageAssetId: input.normalizedImageAssetId,
                        metadata: AdminMetadataSchemaBuilder.createSchema(
                            input: input.metadataValue
                        )
                    )
                )
            )

            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create this blog tag."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create blog tags."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
