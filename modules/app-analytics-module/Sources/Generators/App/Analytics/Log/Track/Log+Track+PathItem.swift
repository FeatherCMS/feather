import FeatherOpenAPI

extension Analytics.Log.Track {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
