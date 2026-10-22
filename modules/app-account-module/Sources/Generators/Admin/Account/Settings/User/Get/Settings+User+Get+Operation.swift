import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.User.Get {
    struct Operation: Settings.User.Operation {
        var operationId: String? { "accountUserSettingsGet" }
        var responseMap: ResponseMap {
            [200: Settings.Get.Response().reference()]
        }
    }
}
