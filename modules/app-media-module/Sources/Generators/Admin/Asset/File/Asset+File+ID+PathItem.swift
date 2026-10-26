import FeatherOpenAPI

extension Asset.File.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Asset.File.Get.Operation() }
        var patch: (any OperationRepresentable)? {
            Asset.File.Patch.Operation()
        }
    }
}
