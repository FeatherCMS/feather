import FeatherOpenAPI

extension Analytics.Log.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            Analytics.Log.Get.Operation()
        }
    }
}
