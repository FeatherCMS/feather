import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule {
    protocol Operation: OperationRepresentable {
        var operationId: String? { get }
    }
}
