import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/media/assets": PathItem(),
                "api/v1/admin/media/assets/query": Query.PathItem(),
                "api/v1/admin/media/assets/resolve": Resolve.PathItem(),
                "api/v1/admin/media/assets/{mediaAssetId}": ID.PathItem(),
                "api/v1/admin/media/assets/{mediaAssetId}/variants":
                    Variant.Query.PathItem(),
            ]
        }
    }
}
