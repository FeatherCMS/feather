import FeatherOpenAPI

extension Role.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Role.Get.Operation() }
        var patch: (any OperationRepresentable)? { Role.Patch.Operation() }
    }
}
