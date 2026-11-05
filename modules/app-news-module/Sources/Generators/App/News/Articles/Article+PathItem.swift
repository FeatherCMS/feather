import FeatherOpenAPI

extension Article {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
    }
}
