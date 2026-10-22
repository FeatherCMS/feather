import FeatherOpenAPI

extension Settings.User {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
        var put: (any OperationRepresentable)? { Put.Operation() }
    }
}
