public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/web/menus": List.PathItem(),
                "api/v1/web/menus/{key}": Key.Get.PathItem(),
            ]
        }
    }
}
