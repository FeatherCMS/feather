import FeatherOpenAPI

extension NewsletterCampaign.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
