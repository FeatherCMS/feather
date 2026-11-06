import FeatherOpenAPI

extension Tag.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Tag.Get.Operation() }
    }
}
