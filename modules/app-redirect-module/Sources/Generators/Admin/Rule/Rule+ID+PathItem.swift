import FeatherOpenAPI

extension Rule.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Rule.Get.Operation() }
        var put: (any OperationRepresentable)? { Rule.Put.Operation() }
        var patch: (any OperationRepresentable)? { Rule.Patch.Operation() }
    }
}
