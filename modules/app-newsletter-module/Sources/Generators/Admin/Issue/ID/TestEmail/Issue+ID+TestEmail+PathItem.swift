import FeatherOpenAPI

extension Issue.ID.TestEmail {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Operation()
        }
    }
}
