import FeatherOpenAPI

extension Author.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Author.Get.Operation() }
    }
}
