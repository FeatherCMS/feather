import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
