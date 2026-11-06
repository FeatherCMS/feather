import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page.List {
    struct Operation: Page.Operation, BearerProtectedOperation {
        var operationId: String? { "pageList" }

        var responseMap: ResponseMap {
            [
                200: Response().reference()
            ]
        }
    }
}
