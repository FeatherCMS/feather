import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogSettings.Put {
    struct Operation: BlogSettings.Operation {
        var operationId: String? { "blogSettingsPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogSettingsUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [200: BlogSettingsDetailResponse().reference()]
        }
    }
}
