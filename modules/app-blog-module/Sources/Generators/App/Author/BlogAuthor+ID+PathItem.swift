import FeatherOpenAPI

extension BlogAuthor.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { BlogAuthor.Get.Operation() }
    }
}
