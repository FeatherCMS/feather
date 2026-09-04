import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddMediaFolderOpenAPIRepository {
    let api: MediaAdminAPIClient
    private let unauthorizedMessage =
        "Please sign in again to create a media folder."

    func createFolder(
        name: String,
        parentId: String?
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaFolderCreate(
                body: .json(.init(parentId: parentId, name: name))
            )
            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create media folders."
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
