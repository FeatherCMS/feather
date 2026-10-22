import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Get {
    struct Operation: BlogOperation {
        var operationId: String? { "blogSettingsGet" }
        var responseMap: ResponseMap {
            [200: BlogRouteSettingsResponse().reference()]
        }
    }
}
