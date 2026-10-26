public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MenuItem {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/web/menus/{menuId}/items":
                    PathItem(),
                "api/v1/admin/web/menus/{menuId}/items/query":
                    Query.PathItem(),
                "api/v1/admin/web/menus/{menuId}/items/{menuItemId}":
                    ID.PathItem(),
                "api/v1/admin/web/menus/{menuId}/items/{menuItemId}/move":
                    Move.PathItem(),
            ]
        }
    }
}
