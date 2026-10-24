public import FeatherOpenAPI

extension Menu.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
        var put: (any OperationRepresentable)? { Put.Operation() }
        var patch: (any OperationRepresentable)? { Patch.Operation() }
    }
}
