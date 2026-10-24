public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/web/menus": PathItem(),
                "api/v1/admin/web/menus/": List.PathItem(),
                "api/v1/admin/web/menus/query": Query.PathItem(),
                "api/v1/admin/web/menus/{menuId}": ID.PathItem(),
            ]
        }
    }
}
