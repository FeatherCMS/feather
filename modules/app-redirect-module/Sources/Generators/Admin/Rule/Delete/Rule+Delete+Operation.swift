import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.Delete {
    struct Operation: Rule.Operation, DeleteOperation {
        var operationId: String? { "redirectRuleRemove" }
    }
}
