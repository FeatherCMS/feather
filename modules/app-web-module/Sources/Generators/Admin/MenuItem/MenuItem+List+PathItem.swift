public import FeatherOpenAPI

extension MenuItem.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { MenuItem.List.Operation() }
    }
}
