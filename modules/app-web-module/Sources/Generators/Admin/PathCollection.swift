import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/web/metadata": WebMetadataPathItems(),
            "api/v1/admin/web/metadata/": WebMetadataListPathItems(),
            "api/v1/admin/web/metadata/search": WebMetadataSearchPathItems(),
            "api/v1/admin/web/metadata/{webMetadataId}":
                WebMetadataIdPathItems(),
            "api/v1/admin/web/pages": WebPagePathItems(),
            "api/v1/admin/web/pages/": WebPageListPathItems(),
            "api/v1/admin/web/pages/search": WebPageSearchPathItems(),
            "api/v1/admin/web/pages/{webPageId}": WebPageIdPathItems(),
            "api/v1/admin/web/menus": WebMenuPathItems(),
            "api/v1/admin/web/menus/": WebMenuListPathItems(),
            "api/v1/admin/web/menus/search": WebMenuSearchPathItems(),
            "api/v1/admin/web/menus/{webMenuId}": WebMenuIdPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items": WebMenuItemPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items/":
                WebMenuItemListPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items/search":
                WebMenuItemSearchPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items/{webMenuItemId}":
                WebMenuItemIdPathItems(),
            "api/v1/admin/web/menus/{webMenuId}/items/{webMenuItemId}/move":
                WebMenuItemMovePathItems(),
            "api/v1/admin/web/settings": WebSettingsPathItems(),
        ]
    }
}
