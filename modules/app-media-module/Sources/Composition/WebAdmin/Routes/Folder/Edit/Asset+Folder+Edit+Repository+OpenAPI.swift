import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Edit.Repository {
    struct OpenAPI {
        let api: MediaAdminAPIClient
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

        func updateFolder(
            id: String,
            name: String
        ) async throws -> Components.Schemas.MediaFolderDetailSchema {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaFolderPatch(
                    path: .init(mediaFolderId: id),
                    query: .init(updateMask: "name"),
                    body: .json(.init(name: name))
                )
                switch response {
                case .ok(let ok):
                    return try ok.body.json
                case .badRequest(let response):
                    let data = try JSONEncoder().encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
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
