public import FeatherOpenAPI

extension Settings {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
        var put: (any OperationRepresentable)? { Put.Operation() }
    }
}
