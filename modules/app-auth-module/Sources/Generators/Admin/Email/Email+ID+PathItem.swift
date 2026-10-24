import FeatherOpenAPI

extension Email.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Email.Get.Operation() }
        var patch: (any OperationRepresentable)? {
            Email.Patch.Operation()
        }
    }
}
