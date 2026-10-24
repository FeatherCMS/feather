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

extension Asset.File.View.Interactor {
    struct Default: Interface {
        let repository: Asset.File.View.Repository.OpenAPI

        func getMediaAsset(
            id: String
        ) async throws -> Asset.File.View.Model {
            async let item = repository.getAsset(id: id)
            async let variants = repository.getVariants(id: id)
            return .init(item: try await item, variants: try await variants)
        }
    }
}
