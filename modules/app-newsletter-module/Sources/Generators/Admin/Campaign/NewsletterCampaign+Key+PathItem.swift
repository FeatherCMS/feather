import FeatherOpenAPI

extension NewsletterCampaign.Key {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            NewsletterCampaign.Get.Operation()
        }
        var patch: (any OperationRepresentable)? {
            NewsletterCampaign.Patch.Operation()
        }
    }
}
