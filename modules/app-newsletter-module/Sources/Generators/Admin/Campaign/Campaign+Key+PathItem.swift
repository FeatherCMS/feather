import FeatherOpenAPI

extension Campaign.Key {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            Campaign.Get.Operation()
        }
        var patch: (any OperationRepresentable)? {
            Campaign.Patch.Operation()
        }
    }
}
