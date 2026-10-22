import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MenuItem {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/web/menus/{webMenuId}/items":
                    PathItem(),
                "api/v1/admin/web/menus/{webMenuId}/items/":
                    List.PathItem(),
                "api/v1/admin/web/menus/{webMenuId}/items/query":
                    Query.PathItem(),
                "api/v1/admin/web/menus/{webMenuId}/items/{webMenuItemId}":
                    ID.PathItem(),
                "api/v1/admin/web/menus/{webMenuId}/items/{webMenuItemId}/move":
                    Move.PathItem(),
            ]
        }
    }
}
