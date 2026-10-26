import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
