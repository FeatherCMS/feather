import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.List {
    struct Operation: Rule.Operation {
        var operationId: String? { "redirectRuleList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
