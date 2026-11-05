import FeatherOpenAPI

extension Asset.Folder.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Asset.Folder.Get.Operation() }
        var patch: (any OperationRepresentable)? {
            Asset.Folder.Patch.Operation()
        }
    }
}
