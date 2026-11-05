import FeatherOpenAPI

extension AuthorLink.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            AuthorLink.Get.Operation()
        }
        var put: (any OperationRepresentable)? {
            AuthorLink.Put.Operation()
        }
        var patch: (any OperationRepresentable)? {
            AuthorLink.Patch.Operation()
        }
    }
}
