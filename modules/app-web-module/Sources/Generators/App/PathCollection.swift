import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/web/settings": WebSiteSettingsPathItems(),
            "api/v1/web/menus": WebMenuListPathItems(),
            "api/v1/web/routes/{slug}": WebMetadataGetPathItems(),
            "api/v1/web/pages/{id}": WebPageGetPathItems(),
        ]
    }
}
