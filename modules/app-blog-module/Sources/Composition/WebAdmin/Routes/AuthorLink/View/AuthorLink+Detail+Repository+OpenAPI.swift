import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Detail.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            authorID: String,
            id: String
        ) async throws -> AuthorLink.Detail.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client.blogAuthorLinkGet(
                        path: .init(
                            blogAuthorId: authorID,
                            blogAuthorLinkId: id
                        ),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                switch response {
                case .ok(let okResponse):
                    let item = try okResponse.body.json
                    return .init(
                        id: item.id,
                        authorID: item.menuId,
                        label: item.label,
                        url: item.url,
                        priority: item.priority,
                        isBlank: item.isBlank,
                        permission: item.permission,
                        notes: item.notes
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
