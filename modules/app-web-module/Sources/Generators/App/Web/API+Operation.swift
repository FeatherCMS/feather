import FeatherOpenAPI
import FeatherOpenAPIGenerator

protocol APIOperation: OperationRepresentable {}

extension APIOperation {
    var tags: [any TagRepresentable] { [Web.Tag()] }
}
