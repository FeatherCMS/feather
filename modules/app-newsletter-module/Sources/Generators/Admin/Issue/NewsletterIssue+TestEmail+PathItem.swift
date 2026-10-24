import FeatherOpenAPI

extension NewsletterIssue.TestEmail {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Operation()
        }
    }
}
