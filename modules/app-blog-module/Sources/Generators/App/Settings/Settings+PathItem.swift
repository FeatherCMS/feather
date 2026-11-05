import FeatherOpenAPI

extension Settings {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Get.Operation() }
    }
}
