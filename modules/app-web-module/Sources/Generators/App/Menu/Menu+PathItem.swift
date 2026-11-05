public import FeatherOpenAPI

extension Menu {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
    }
}
