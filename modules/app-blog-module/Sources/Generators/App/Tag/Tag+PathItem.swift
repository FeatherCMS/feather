import FeatherOpenAPI

extension Tag {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
    }
}
