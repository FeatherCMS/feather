import FeatherOpenAPI

extension NewsletterSubscriber.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
