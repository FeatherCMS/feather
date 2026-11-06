import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Get {
    struct Operation: Settings.Operation {
        var operationId: String? { "accountSettingsGet" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
