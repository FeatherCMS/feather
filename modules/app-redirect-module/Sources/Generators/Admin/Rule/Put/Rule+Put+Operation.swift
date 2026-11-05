import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.Put {
    struct Operation: Rule.IDOperation {
        var operationId: String? { "redirectRuleUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Rule.Get.Response().reference(),
                404: CustomResponse(description: "Redirect rule not found"),
            ]
        }
    }
}
