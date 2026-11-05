import FeatherOpenAPI

extension Article.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Article.Get.Operation() }
        var put: (any OperationRepresentable)? { Article.Put.Operation() }
    }
}
