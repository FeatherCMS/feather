import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Get {
    struct Operation: Settings.Operation {
        var operationId: String? { "settingsGet" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
