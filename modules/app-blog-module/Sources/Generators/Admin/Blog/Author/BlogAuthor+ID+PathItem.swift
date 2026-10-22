import FeatherOpenAPI

extension BlogAuthor.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { BlogAuthor.Get.Operation() }
        var put: (any OperationRepresentable)? { BlogAuthor.Put.Operation() }
        var patch: (any OperationRepresentable)? {
            BlogAuthor.Patch.Operation()
        }
    }
}
