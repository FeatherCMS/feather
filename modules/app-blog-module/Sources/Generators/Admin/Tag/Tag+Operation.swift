import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag {
    protocol Operation: BearerProtectedOperation {}
    protocol IdentifiableOperation: Operation {}
}

extension Tag.Operation {
    var tags: [any TagRepresentable] { [BlogTagTag()] }
}

extension Tag.IdentifiableOperation {
    var parameters: [any ParameterRepresentable] {
        [BlogTagIdParameter().reference()]
    }
}
