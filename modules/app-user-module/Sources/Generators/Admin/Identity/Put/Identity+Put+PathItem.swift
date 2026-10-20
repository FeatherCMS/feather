import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Put {
    struct PathItem: PathItemRepresentable {
        var put: (any OperationRepresentable)? { Operation() }
    }
}
