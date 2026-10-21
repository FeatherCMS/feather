import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct RedirectRuleListOperation: RedirectRuleOperation {
    var operationId: String? { "redirectRuleList" }

    var responseMap: ResponseMap {
        [200: RedirectRuleListResponse().reference()]
    }
}
