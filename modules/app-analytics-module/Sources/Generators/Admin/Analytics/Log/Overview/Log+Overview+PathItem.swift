import FeatherOpenAPI

extension Analytics.Log.Overview {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
