import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            ["api/v1/web/pages/{id}": ID.Get.PathItem()]
        }
    }
}
