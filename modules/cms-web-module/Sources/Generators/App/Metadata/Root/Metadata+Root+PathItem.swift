public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Root {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
