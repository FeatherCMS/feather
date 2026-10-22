import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Get {
    struct Operation: Settings.Operation {
        var operationId: String? { "blogSettingsGet" }
        var responseMap: ResponseMap {
            [200: BlogSettingsDetailResponse().reference()]
        }
    }
}
