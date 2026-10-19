import FeatherOpenAPI

extension Permission.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Permission.Get.Operation() }
        var put: (any OperationRepresentable)? { Permission.Put.Operation() }
        var patch: (any OperationRepresentable)? {
            Permission.Patch.Operation()
        }
    }
}
