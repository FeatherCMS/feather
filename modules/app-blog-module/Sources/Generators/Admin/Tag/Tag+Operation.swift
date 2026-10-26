import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag {
    protocol Operation: BearerProtectedOperation {}
    protocol IdentifiableOperation: Operation {}
}

extension Tag.Operation {
    var tags: [any TagRepresentable] { [Tag.Tag()] }
}

extension Tag.IdentifiableOperation {
    var parameters: [any ParameterRepresentable] {
        [Tag.Parameters.ID().reference()]
    }
}
