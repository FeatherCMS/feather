import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct RedirectRuleCreateOperation: RedirectRuleOperation {
    var operationId: String? { "redirectRuleCreate" }

    var requestBody: (any RequestBodyRepresentable)? {
        RedirectRuleRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [201: RedirectRuleDetailResponse().reference()]
    }
}
