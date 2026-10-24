public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.Key.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
