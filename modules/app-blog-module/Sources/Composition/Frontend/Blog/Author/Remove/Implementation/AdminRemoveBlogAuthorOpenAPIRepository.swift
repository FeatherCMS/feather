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
import WebBuilders
import WebComponents
import WebFrontend

struct AdminRemoveBlogAuthorOpenAPIRepository:
    AdminRemoveBlogAuthorRepository
{
    let api: BlogAdminAPIClient

    func get(
        id: String
    ) async throws -> BlogAuthorDetailsModel {
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
                    profileImage: nil,
                    metadata: AdminMetadataSchemaBuilder.formValue(
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

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.blogAuthorRemove(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
