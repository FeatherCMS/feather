import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Put {
    struct Operation: Settings.Operation {
        var operationId: String? { "blogSettingsPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogSettingsUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [200: BlogSettingsDetailResponse().reference()]
        }
    }
}
