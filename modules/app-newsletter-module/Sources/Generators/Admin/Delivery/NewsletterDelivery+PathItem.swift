import FeatherOpenAPI

extension NewsletterDelivery {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            List.Operation()
        }
    }
}
