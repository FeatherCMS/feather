public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page.ID.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
