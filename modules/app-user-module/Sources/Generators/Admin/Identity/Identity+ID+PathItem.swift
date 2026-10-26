import FeatherOpenAPI

extension Identity.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Identity.Get.Operation() }
        var patch: (any OperationRepresentable)? { Identity.Patch.Operation() }
    }
}
