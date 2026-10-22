import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Settings.Get {
    struct Operation: Settings.Operation {
        var operationId: String? { "webSiteSettings" }
        var responseMap: ResponseMap {
            [200: WebSiteSettingsResponse().reference()]
        }
    }
}
