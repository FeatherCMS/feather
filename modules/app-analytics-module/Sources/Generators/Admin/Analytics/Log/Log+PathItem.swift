import FeatherOpenAPI

extension Analytics.Log {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
    }
}
