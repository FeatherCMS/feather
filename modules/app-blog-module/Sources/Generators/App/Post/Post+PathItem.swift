import FeatherOpenAPI

extension Post {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
    }
}
