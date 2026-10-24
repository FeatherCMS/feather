public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Article {
    protocol Operation: OperationRepresentable {}
    protocol IdentifiableOperation: Operation {}
}

extension Article.Operation {
    var tags: [any TagRepresentable] { [News.Tag()] }
}

extension Article.IdentifiableOperation {
    var parameters: [any ParameterRepresentable] {
        [Article.Parameters.ID().reference()]
    }
}
