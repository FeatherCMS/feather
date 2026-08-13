import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/media/assets": MediaAssetPathItems(),
            "api/v1/admin/media/assets/search": MediaAssetSearchPathItems(),
            "api/v1/admin/media/assets/{mediaAssetId}": MediaAssetIdPathItems(),
            "api/v1/admin/media/assets/{mediaAssetId}/variants":
                MediaAssetVariantPathItems(),
            "api/v1/admin/media/folders": MediaFolderPathItems(),
            "api/v1/admin/media/folders/search": MediaFolderSearchPathItems(),
            "api/v1/admin/media/folders/{mediaFolderId}":
                MediaFolderIdPathItems(),
            "api/v1/admin/media/processors": MediaProcessorPathItems(),
            "api/v1/admin/media/processors/search":
                MediaProcessorSearchPathItems(),
            "api/v1/admin/media/processors/{mediaProcessorId}":
                MediaProcessorIdPathItems(),
        ]
    }
}
