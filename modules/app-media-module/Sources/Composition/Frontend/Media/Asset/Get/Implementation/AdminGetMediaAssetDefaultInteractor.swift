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

struct AdminGetMediaAssetDefaultInteractor: AdminGetMediaAssetInteractor {
    let repository: AdminMediaAssetOpenAPIRepository

    func getMediaAsset(
        id: String
    ) async throws -> AdminGetMediaAssetModel {
        async let item = repository.getAsset(id: id)
        async let variants = repository.getVariants(id: id)
        return .init(item: try await item, variants: try await variants)
    }
}
