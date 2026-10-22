import FeatherOpenAPI

extension BlogTag.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { BlogTag.Get.Operation() }
        var put: (any OperationRepresentable)? { BlogTag.Put.Operation() }
        var patch: (any OperationRepresentable)? { BlogTag.Patch.Operation() }
    }
}
