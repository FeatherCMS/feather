public import FeatherOpenAPI

extension Metadata.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Metadata.Get.Operation() }
        var put: (any OperationRepresentable)? { Metadata.Put.Operation() }
        var patch: (any OperationRepresentable)? { Metadata.Patch.Operation() }
    }
}
