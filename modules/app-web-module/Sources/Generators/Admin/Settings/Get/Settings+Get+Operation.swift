import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Settings.Get {
    struct Operation: Settings.Operation {
        var operationId: String? { "settingsGet" }

        var responseMap: ResponseMap {
            [200: SettingsDetailResponse().reference()]
        }
    }
}
