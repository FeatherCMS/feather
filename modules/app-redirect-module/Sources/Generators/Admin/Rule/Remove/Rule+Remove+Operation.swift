import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct RedirectRuleRemoveOperation: RedirectRuleOperation, DeleteOperation {
    var operationId: String? { "redirectRuleRemove" }
}
