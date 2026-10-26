import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable.List {
    struct Operation: Variable.Operation, BearerProtectedOperation {
        var operationId: String? { "systemVariableList" }
        var parameters: [any ParameterRepresentable] {
            [
                Variable.Parameters.Search().reference(),
                Variable.Parameters.IDs().reference(),
                Variable.Parameters.Limit().reference(),
            ]
        }
        var responseMap: ResponseMap { [200: Response().reference()] }
    }
}
