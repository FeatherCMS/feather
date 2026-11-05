import FeatherOpenAPI

extension Variant.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Variant.Get.Operation() }
        var patch: (any OperationRepresentable)? { Variant.Patch.Operation() }
    }
}
