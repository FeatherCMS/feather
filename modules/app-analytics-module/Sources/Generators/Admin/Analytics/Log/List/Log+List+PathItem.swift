import FeatherOpenAPI

extension Analytics.Log.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
