import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMediaAssetDefaultInteractor: AdminViewMediaAssetInteractor {
    let repository: AdminViewMediaAssetOpenAPIRepository

    func getMediaAsset(
        id: String
    ) async throws -> AdminViewMediaAssetModel {
        async let item = repository.getAsset(id: id)
        async let variants = repository.getVariants(id: id)
        return .init(item: try await item, variants: try await variants)
    }
}
