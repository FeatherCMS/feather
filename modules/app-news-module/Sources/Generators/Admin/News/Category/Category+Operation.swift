import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Category {
    protocol Operation: BearerProtectedOperation {}
    protocol IdentifiableOperation: Operation {}
}

extension Category.Operation {
    var tags: [any TagRepresentable] { [Category.Tag()] }
}

extension Category.IdentifiableOperation {
    var parameters: [any ParameterRepresentable] {
        [Category.Parameters.ID().reference()]
    }
}
