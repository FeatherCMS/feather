import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Post {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
