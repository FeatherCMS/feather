import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct RedirectRuleGetOperation: RedirectRuleIDOperation {
    var operationId: String? { "redirectRuleGet" }

    var responseMap: ResponseMap {
        [
            200: RedirectRuleDetailResponse().reference(),
            404: CustomResponse(description: "Redirect rule not found"),
        ]
    }
}
