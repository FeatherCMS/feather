import FeatherOpenAPI

extension Tag.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Tag.Get.Operation() }
        var put: (any OperationRepresentable)? { Tag.Put.Operation() }
        var patch: (any OperationRepresentable)? { Tag.Patch.Operation() }
    }
}
