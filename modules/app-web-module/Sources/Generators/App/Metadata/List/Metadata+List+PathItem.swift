public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
