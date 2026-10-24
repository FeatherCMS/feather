import FeatherOpenAPI

extension NewsletterSubscriber.Email {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            NewsletterSubscriber.Get.Operation()
        }
        var patch: (any OperationRepresentable)? {
            NewsletterSubscriber.Patch.Operation()
        }
    }
}
