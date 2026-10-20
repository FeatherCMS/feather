import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Delete {
    struct PathItem: PathItemRepresentable {
        var delete: (any OperationRepresentable)? { Operation() }
    }
}
