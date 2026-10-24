import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Settings.Put {
    struct Operation: Settings.Operation {
        var operationId: String? { "settingsPut" }

        var requestBody: (any RequestBodyRepresentable)? {
            SettingsUpdateRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [200: SettingsDetailResponse().reference()]
        }
    }
}
