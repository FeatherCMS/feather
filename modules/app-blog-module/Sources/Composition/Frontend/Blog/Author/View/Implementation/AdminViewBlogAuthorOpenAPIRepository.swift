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

struct AdminViewBlogAuthorOpenAPIRepository: AdminViewBlogAuthorRepository {
    let api: BlogAdminAPIClient

    func get(
        id: String
    ) async throws -> BlogAuthorDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            async let authorResponse =
                client
                .blogAuthorGet(
                    path: .init(blogAuthorId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            async let linksResponse =
                client
                .blogAuthorLinkSearch(
                    path: .init(blogAuthorId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 100, number: 1),
                            filters: .init(search: nil)
                        )
                    )
                )
            let response = try await authorResponse
            switch response {
            case .ok(let okResponse):
                let author = try okResponse.body.json
                let items:
                    [BlogAdminAPI.Components.Schemas
                        .BlogAuthorLinkListItemSchema]
                switch try await linksResponse {
                case .ok(let linksOk):
                    items = try linksOk.body.json.data.items
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let undocumentedResponse):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: undocumentedResponse.body
                    )
                }
                return .init(
                    id: author.id,
                    name: author.name,
                    excerpt: author.excerpt,
                    content: author.content,
                    profileImageAssetId: author.profileImageAssetId,
                    profileImage: try await api.mediaAdminAPI()
                        .loadImageAsset(assetId: author.profileImageAssetId),
                    metadata: AdminMetadataSchemaBuilder.formValue(
                        from: author.metadata,
                        fallbackTitle: author.name,
                        fallbackExcerpt: author.excerpt
                    ),
                    items: items
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
