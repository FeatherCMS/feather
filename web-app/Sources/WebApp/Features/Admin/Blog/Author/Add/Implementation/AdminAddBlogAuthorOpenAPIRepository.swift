import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddBlogAuthorOpenAPIRepository: AdminAddBlogAuthorRepository {
    let api: AdminAPI

    func create(
        input: BlogAuthorFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorCreate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        name: input.normalizedName,
                        excerpt: input.normalizedExcerpt,
                        content: input.normalizedContent,
                        profileImageAssetId: input
                            .normalizedProfileImageAssetId,
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
                    message: "Please sign in again to create this blog author."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot create blog authors."
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
