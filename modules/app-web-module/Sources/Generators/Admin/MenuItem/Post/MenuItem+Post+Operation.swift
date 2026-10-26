import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension MenuItem.Post {
    struct Operation: MenuItem.MenuOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                201: MenuItem.Get.Response().reference()
            ]
        }
    }
}
