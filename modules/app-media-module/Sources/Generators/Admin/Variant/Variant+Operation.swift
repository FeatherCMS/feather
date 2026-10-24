import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant {
    protocol Operation: BearerProtectedOperation {}
    protocol IDOperation: Operation {}
}

extension Variant.Operation {
    var tags: [any TagRepresentable] { [MediaVariantTag()] }
}

extension Variant.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [MediaVariantIdParameter().reference()]
    }
}
