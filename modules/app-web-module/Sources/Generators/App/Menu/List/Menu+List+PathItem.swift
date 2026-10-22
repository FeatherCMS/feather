public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
