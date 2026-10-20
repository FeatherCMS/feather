import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Put {
    struct PathItem: PathItemRepresentable {
        var put: (any OperationRepresentable)? { Operation() }
    }
}
