import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
