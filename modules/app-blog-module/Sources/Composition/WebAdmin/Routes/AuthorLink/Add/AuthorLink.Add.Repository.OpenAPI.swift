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

extension AuthorLink.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func create(
            authorID: String,
            input: AuthorLink.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogAuthorLinkPost(
                    path: .init(blogAuthorId: authorID),
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
                case .created:
                    return
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
