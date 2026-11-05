import FeatherOpenAPI

extension Profile.CurrentUser {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
        var put: (any OperationRepresentable)? { Put.Operation() }
    }
}
