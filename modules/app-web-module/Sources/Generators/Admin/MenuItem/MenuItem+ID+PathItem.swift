public import FeatherOpenAPI

extension MenuItem.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { MenuItem.Get.Operation() }
        var put: (any OperationRepresentable)? { MenuItem.Put.Operation() }
        var patch: (any OperationRepresentable)? { MenuItem.Patch.Operation() }
    }
}
