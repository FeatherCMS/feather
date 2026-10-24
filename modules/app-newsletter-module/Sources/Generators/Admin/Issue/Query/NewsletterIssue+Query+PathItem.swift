import FeatherOpenAPI

extension NewsletterIssue.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
