import FeatherOpenAPI

struct NewsletterCampaignPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsletterCampaignListOperation() }
    var post: (any OperationRepresentable)? {
        NewsletterCampaignCreateOperation()
    }
    var delete: (any OperationRepresentable)? {
        NewsletterCampaignRemoveOperation()
    }
}
struct NewsletterCampaignIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsletterCampaignGetOperation() }
    var patch: (any OperationRepresentable)? {
        NewsletterCampaignUpdateOperation()
    }
}
