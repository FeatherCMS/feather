import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Article {
    protocol Operation: BearerProtectedOperation {}
    protocol IdentifiableOperation: Operation {}
}

extension Article.Operation {
    var tags: [any TagRepresentable] { [Article.Tag()] }
}

extension Article.IdentifiableOperation {
    var parameters: [any ParameterRepresentable] {
        [Article.Parameters.ID().reference()]
    }
}
