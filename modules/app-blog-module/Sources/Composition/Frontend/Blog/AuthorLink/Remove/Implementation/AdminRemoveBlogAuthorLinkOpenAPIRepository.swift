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

struct AdminRemoveBlogAuthorLinkOpenAPIRepository:
    AdminRemoveBlogAuthorLinkRepository
{
    let api: BlogAdminAPIClient

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorLinkGet(
                path: .init(blogAuthorId: menuId, blogAuthorLinkId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let item = try okResponse.body.json
                return .init(
                    id: item.id,
                    menuId: item.menuId,
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

    func delete(
        menuId: String,
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.blogAuthorLinkRemove(
                path: .init(blogAuthorId: menuId),
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
