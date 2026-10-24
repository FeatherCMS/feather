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

extension AuthorLink.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            authorID: String,
            id: String
        ) async throws -> AuthorLink.View.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogAuthorLinkGet(
                    path: .init(blogAuthorId: authorID, blogAuthorLinkId: id),
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

        func update(
            authorID: String,
            id: String,
            input: AuthorLink.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogAuthorLinkPut(
                    path: .init(blogAuthorId: authorID, blogAuthorLinkId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            label: input.normalizedLabel,
                            url: input.normalizedURL,
                            priority: input.parsedPriority ?? 0,
                            isBlank: input.isBlank.value,
                            permission: input.normalizedPermission,
                            notes: input.normalizedNotes
                        )
                    )
                )
                switch response {
                case .ok:
                    return
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
