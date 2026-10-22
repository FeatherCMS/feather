import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag {
    protocol Operation: BearerProtectedOperation {}
    protocol IdentifiableOperation: Operation {}
}

extension BlogTag.Operation {
    var tags: [any TagRepresentable] { [BlogTagTag()] }
}

extension BlogTag.IdentifiableOperation {
    var parameters: [any ParameterRepresentable] {
        [BlogTagIdParameter().reference()]
    }
}
