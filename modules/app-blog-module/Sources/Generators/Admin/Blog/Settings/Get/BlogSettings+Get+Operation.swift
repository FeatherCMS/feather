import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogSettings.Get {
    struct Operation: BlogSettings.Operation {
        var operationId: String? { "blogSettingsGet" }
        var responseMap: ResponseMap {
            [200: BlogSettingsDetailResponse().reference()]
        }
    }
}
