import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct AdminAddBlogPostOpenAPIRepository: AdminAddBlogPostRepository {
    let api: BlogAdminAPIClient

    func create(
        input: BlogPostFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogPostCreate(
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
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create this blog post."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create blog posts."
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
