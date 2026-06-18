import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditBlogSettingsOpenAPIRepository:
    AdminEditBlogSettingsRepository
{
    let api: AdminAPI
    private let loadUnauthorizedMessage =
        "Please sign in again to load blog settings."
    private let loadForbiddenMessage =
        "Your account cannot access blog settings."
    private let saveUnauthorizedMessage =
        "Please sign in again to save blog settings."
    private let saveForbiddenMessage =
        "Your account cannot update blog settings."

    func loadSettings() async throws -> AdminEditBlogSettingsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogSettingsGet(
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let body = try okResponse.body.json
                return .init(
                    postListPath: body.postListPath,
                    authorListPath: body.authorListPath,
                    tagListPath: body.tagListPath,
                    postPathPrefix: body.postPathPrefix,
                    authorPathPrefix: body.authorPathPrefix,
                    tagPathPrefix: body.tagPathPrefix,
                    hasMissingVariables: false
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: loadUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: loadForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func saveSettings(
        input: AdminEditBlogSettingsFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogSettingsUpdate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        postListPath: input.normalizedPostListPath,
                        authorListPath: input.normalizedAuthorListPath,
                        tagListPath: input.normalizedTagListPath,
                        postPathPrefix: input.normalizedPostPathPrefix,
                        authorPathPrefix: input.normalizedAuthorPathPrefix,
                        tagPathPrefix: input.normalizedTagPathPrefix
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: saveUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: saveForbiddenMessage
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
