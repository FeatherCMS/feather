import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.Post {
    struct Operation: Rule.Operation {
        var operationId: String? { "redirectRuleCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Rule.Get.Response().reference()]
        }
    }
}
