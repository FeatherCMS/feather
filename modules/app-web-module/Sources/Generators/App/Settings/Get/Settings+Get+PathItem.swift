import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
