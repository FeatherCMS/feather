import FeatherOpenAPI

extension BlogAuthor {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
    }
}
