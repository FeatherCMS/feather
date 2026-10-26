import FeatherOpenAPI

extension Credential.ID {

    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Credential.Get.Operation() }
        var put: (any OperationRepresentable)? { Credential.Put.Operation() }
        var patch: (any OperationRepresentable)? {
            Credential.Patch.Operation()
        }
    }
}
