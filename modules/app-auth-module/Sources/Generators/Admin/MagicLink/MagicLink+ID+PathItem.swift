import FeatherOpenAPI

extension MagicLink.ID {

    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { MagicLink.Get.Operation() }
        var put: (any OperationRepresentable)? { MagicLink.Put.Operation() }
        var patch: (any OperationRepresentable)? { MagicLink.Patch.Operation() }
    }
}
