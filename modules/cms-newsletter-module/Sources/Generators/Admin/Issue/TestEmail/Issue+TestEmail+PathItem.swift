import FeatherOpenAPI

extension Issue.TestEmail {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Operation()
        }
    }
}
