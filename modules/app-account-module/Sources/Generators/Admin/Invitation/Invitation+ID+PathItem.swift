import FeatherOpenAPI

extension Invitation.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Invitation.Get.Operation() }
        var put: (any OperationRepresentable)? { Invitation.Put.Operation() }
        var patch: (any OperationRepresentable)? {
            Invitation.Patch.Operation()
        }
    }
}
