import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant {
    protocol Operation: BearerProtectedOperation {}
    protocol IDOperation: Operation {}
}

extension Variant.Operation {
    var tags: [any TagRepresentable] { [Variant.Tag()] }
}

extension Variant.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [Variant.Parameters.ID().reference()]
    }
}
