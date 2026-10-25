import FeatherOpenAPI

extension Campaign.Subscribe {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Operation()
        }
    }
}
