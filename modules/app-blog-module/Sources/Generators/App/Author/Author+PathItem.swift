import FeatherOpenAPI

extension Author {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
    }
}
