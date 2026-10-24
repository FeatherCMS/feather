import FeatherOpenAPI

extension NewsletterCampaign.Unsubscribe {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Operation()
        }
    }
}
