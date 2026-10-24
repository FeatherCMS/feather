import FeatherOpenAPI

extension NewsletterIssue.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            NewsletterIssue.Get.Operation()
        }
        var patch: (any OperationRepresentable)? {
            NewsletterIssue.Patch.Operation()
        }
    }
}
