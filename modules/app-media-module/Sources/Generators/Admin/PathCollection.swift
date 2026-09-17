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
            "api/v1/admin/media/processors": MediaProcessorPathItems(),
            "api/v1/admin/media/processors/list":
                MediaProcessorListPathItems(),
            "api/v1/admin/media/processors/{mediaProcessorId}":
                MediaProcessorIdPathItems(),
        ]
    }
}
