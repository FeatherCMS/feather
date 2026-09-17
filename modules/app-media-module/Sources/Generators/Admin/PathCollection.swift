import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/media/assets": MediaAssetPathItems(),
            "api/v1/admin/media/assets/list": MediaAssetListPathItems(),
            "api/v1/admin/media/assets/resolve": MediaAssetResolvePathItems(),
            "api/v1/admin/media/assets/{mediaAssetId}": MediaAssetIdPathItems(),
            "api/v1/admin/media/assets/{mediaAssetId}/variants":
                MediaAssetVariantPathItems(),
            "api/v1/admin/media/folders": MediaFolderPathItems(),
            "api/v1/admin/media/folders/list": MediaFolderListPathItems(),
            "api/v1/admin/media/folders/{mediaFolderId}":
                MediaFolderIdPathItems(),
            "api/v1/admin/media/variants": MediaVariantPathItems(),
            "api/v1/admin/media/variants/list": MediaVariantListPathItems(),
            "api/v1/admin/media/variants/{mediaVariantId}": MediaVariantIdPathItems(),
            "api/v1/admin/media/variants/{mediaVariantId}/processors":
                MediaVariantProcessorsPathItems(),
            "api/v1/admin/media/variants/{mediaVariantId}/processors/list":
                MediaVariantProcessorsListPathItems(),
            "api/v1/admin/media/variants/{mediaVariantId}/processors/{mediaVariantProcessorId}":
                MediaVariantProcessorIdPathItems(),
        ]
    }
}
