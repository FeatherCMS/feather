import FeatherOpenAPI

extension NewsletterCampaign.Subscribe {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Operation()
        }
    }
}
