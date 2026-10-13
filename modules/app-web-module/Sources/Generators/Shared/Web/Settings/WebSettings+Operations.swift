import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct WebSiteSettingsOperation: WebOperation {
    var responseMap: ResponseMap {
        [200: WebSiteSettingsResponse().reference()]
    }
}
