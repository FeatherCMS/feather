import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable.Delete {
    struct Operation: Variable.Operation, DeleteOperation {
        var operationId: String? { "systemVariableDelete" }
    }
}
