import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.User.Put {
    struct Operation: Settings.User.Operation {
        var operationId: String? { "accountUserSettingsUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            Settings.Put.RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [200: Settings.Get.Response().reference()]
        }
    }
}
