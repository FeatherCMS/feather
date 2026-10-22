import FeatherOpenAPI

extension BlogAuthorLink.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            BlogAuthorLink.Get.Operation()
        }
        var put: (any OperationRepresentable)? {
            BlogAuthorLink.Put.Operation()
        }
        var patch: (any OperationRepresentable)? {
            BlogAuthorLink.Patch.Operation()
        }
    }
}
