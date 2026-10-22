import FeatherOpenAPI

extension BlogTag.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { BlogTag.Get.Operation() }
    }
}
