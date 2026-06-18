import AdminOpenAPI
import Foundation

struct AdminEditMediaFolderOpenAPIRepository {
    let api: AdminAPI
    private let loadUnauthorizedMessage =
        "Please sign in again to load this media folder."
    private let updateUnauthorizedMessage =
        "Please sign in again to update this media folder."

    func getFolder(
        id: String
    ) async throws -> Components.Schemas.MediaFolderDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaFolderGet(
                path: .init(mediaFolderId: id)
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media folder not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: loadUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access media folders."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func updateFolder(
        id: String,
        name: String
    ) async throws -> Components.Schemas.MediaFolderDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaFolderUpdate(
                path: .init(mediaFolderId: id),
                body: .json(.init(name: name))
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media folder not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: updateUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit media folders."
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
