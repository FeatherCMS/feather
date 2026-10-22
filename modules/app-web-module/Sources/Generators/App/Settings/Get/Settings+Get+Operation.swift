import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Settings.Get {
    struct Operation: Settings.Operation {
        var operationId: String? { "siteSettings" }
        var responseMap: ResponseMap {
            [200: SiteSettingsResponse().reference()]
        }
    }
}
