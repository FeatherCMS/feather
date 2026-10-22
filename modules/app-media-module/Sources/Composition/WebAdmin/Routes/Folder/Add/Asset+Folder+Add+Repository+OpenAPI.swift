import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Add.Repository {
    struct OpenAPI {
        let api: MediaAdminAPIClient
        private let unauthorizedMessage =
            "Please sign in again to create a media folder."

        func createFolder(
            name: String,
            parentId: String?
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaFolderPost(
                    body: .json(.init(parentId: parentId, name: name))
                )
                switch response {
                case .created:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .conflict:
                    throw OpenAPIRepositoryError.conflict
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
