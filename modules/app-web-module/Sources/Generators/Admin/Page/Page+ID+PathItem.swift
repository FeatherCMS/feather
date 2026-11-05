public import FeatherOpenAPI

extension Page.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Page.Get.Operation() }
        var put: (any OperationRepresentable)? { Page.Put.Operation() }
        var patch: (any OperationRepresentable)? { Page.Patch.Operation() }
    }
}
