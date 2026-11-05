import FeatherOpenAPI

extension Category.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Category.Get.Operation() }
        var put: (any OperationRepresentable)? { Category.Put.Operation() }
    }
}
