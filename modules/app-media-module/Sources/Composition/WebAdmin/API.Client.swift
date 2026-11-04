import AsyncHTTPClient
import FeatherValidation
import Foundation
public import FeatherWebAdmin
public import FeatherWebShared
import HTML
import Hummingbird
public import MediaAdminAPI
import MediaModule
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension API {
    public struct Client: Sendable {
        public let client: MediaAdminAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext,
            timeoutSeconds: Int = 3
        ) {
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(
                        client: .shared,
                        timeout: .seconds(Int64(max(1, timeoutSeconds)))
                    )
                ),
                middlewares: [
                    ClientAPIAuthMiddleware(
                        sessionToken: requestContext.sessionToken
                    )
                ]
            )
        }

        public func loadImageAsset(
            assetId: String?,
            variants: [String] = ["preview"]
        ) async throws -> AdminMediaAsset? {
            try await Asset.File.View.Repository.OpenAPI(api: self)
                .loadImageAsset(assetId: assetId, variants: variants)
        }

        public func resolveAssets(
            ids: [String],
            variants: [String]? = nil
        ) async throws -> [MediaAdminAPI.Components.Schemas
            .MediaAssetResolveItemSchema]
        {
            try await Asset.File.List.Repository.OpenAPI(api: self)
                .resolveAssets(ids: ids, variants: variants)
        }

        public func moveFolder(
            fromPath: String,
            toPath: String
        ) async throws {
            let source = fromPath.split(separator: "/").map(String.init)
            let destination = toPath.split(separator: "/").map(String.init)
            guard !source.isEmpty, !destination.isEmpty,
                source.count > 1, destination.count > 1,
                source.first == destination.first
            else {
                throw OpenAPIRepositoryError.transport(
                    description: "Invalid media folder move paths."
                )
            }

            var parentId: String?
            var sourceId: String?
            for (index, segment) in source.enumerated() {
                let folders = try await listFolders(parentId: parentId)
                guard let folder = folders.first(where: { $0.slug == segment })
                else {
                    throw OpenAPIRepositoryError.notFound
                }
                if index == source.count - 1 { sourceId = folder.id }
                parentId = folder.id
            }
            guard let sourceId else {
                throw OpenAPIRepositoryError.notFound
            }

            parentId = nil
            for segment in destination.dropLast() {
                var folders = try await listFolders(parentId: parentId)
                if let folder = folders.first(where: { $0.slug == segment }) {
                    parentId = folder.id
                    continue
                }
                do {
                    try await createFolder(name: segment, parentId: parentId)
                }
                catch OpenAPIRepositoryError.conflict {
                    // A concurrent save may have created the same path.
                }
                folders = try await listFolders(parentId: parentId)
                guard let folder = folders.first(where: { $0.slug == segment })
                else {
                    throw OpenAPIRepositoryError.notFound
                }
                parentId = folder.id
            }

            let destinationParentId = parentId
            let destinationName = destination[destination.count - 1]
            try await withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaFolderPatch(
                    path: .init(mediaFolderId: sourceId),
                    query: .init(updateMask: "name,parentId"),
                    body: .json(
                        .init(name: destinationName, parentId: destinationParentId)
                    )
                )
                switch response {
                case .ok:
                    return
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
                    throw try await failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        private func listFolders(
            parentId: String?
        ) async throws -> [MediaAdminAPI.Components.Schemas.MediaFolderListItemSchema] {
            try await withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaFolderList(
                    .init(query: .init(parentId: parentId))
                )
                switch response {
                case .ok(let ok): return try ok.body.json
                case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                case .forbidden: throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        private func createFolder(
            name: String,
            parentId: String?
        ) async throws {
            try await withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaFolderPost(
                    body: .json(.init(parentId: parentId, name: name))
                )
                switch response {
                case .created: return
                case .conflict: throw OpenAPIRepositoryError.conflict
                case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                case .forbidden: throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (MediaAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            do { return try await operation(client) }
            catch let error as OpenAPIRepositoryError { throw error }
            catch {
                throw OpenAPIRepositoryError.transport(
                    description: String(describing: error)
                )
            }
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            OpenAPIRepositoryError.parsedFailure(
                statusCode: statusCode,
                responseBody: try await responseBody?.collectString()
            )
        }

    }
}
