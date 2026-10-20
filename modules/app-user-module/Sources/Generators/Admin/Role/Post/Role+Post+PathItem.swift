import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Post {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
