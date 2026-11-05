import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MenuItem.List {
    struct Operation: MenuItem.MenuOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemList" }
        var responseMap: ResponseMap {
            [
                200: Response().reference()
            ]
        }
    }
}
