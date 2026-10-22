import FeatherOpenAPI

extension BlogSettings {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
        var put: (any OperationRepresentable)? { Put.Operation() }
    }
}
