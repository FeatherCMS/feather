import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/redirect/rules": Get.PathItem()
            ]
        }
    }
}
