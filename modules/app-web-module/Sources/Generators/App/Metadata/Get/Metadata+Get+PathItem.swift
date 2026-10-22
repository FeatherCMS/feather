import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
