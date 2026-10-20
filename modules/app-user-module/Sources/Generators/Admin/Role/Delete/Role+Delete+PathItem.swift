import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Delete {
    struct PathItem: PathItemRepresentable {
        var delete: (any OperationRepresentable)? { Operation() }
    }
}
