import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveMediaAssetOpenAPIRepository {
    let api: MediaAdminAPIClient

    func deleteAsset(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.mediaAssetNodeRemove(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
