import FeatherOpenAPI

extension Campaign.Unsubscribe {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Operation()
        }
    }
}
