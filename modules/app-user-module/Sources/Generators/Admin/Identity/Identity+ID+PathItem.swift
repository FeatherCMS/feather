import FeatherOpenAPI

extension Identity.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Identity.Get.Operation() }
        var put: (any OperationRepresentable)? { Identity.Put.Operation() }
        var patch: (any OperationRepresentable)? { Identity.Patch.Operation() }
    }
}
