import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func deleteAsset(
            id: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.mediaAssetDelete(
                    body: .json(.init(ids: [id]))
                )
            }
        }
    }
}
