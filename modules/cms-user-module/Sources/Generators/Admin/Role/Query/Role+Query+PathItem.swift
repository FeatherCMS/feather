import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
