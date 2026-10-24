import FeatherOpenAPI

extension NewsletterIssue.ID.TestEmail {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Operation()
        }
    }
}
