import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/media/folders": PathItem(),
                "api/v1/admin/media/folders/query": Query.PathItem(),
                "api/v1/admin/media/folders/{mediaFolderId}": ID.PathItem(),
            ]
        }
    }
}
