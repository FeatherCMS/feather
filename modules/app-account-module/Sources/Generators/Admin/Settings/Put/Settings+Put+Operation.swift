import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Put {
    struct Operation: Settings.Operation {
        var operationId: String? { "accountSettingsUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [200: Settings.Get.Response().reference()]
        }
    }
}
