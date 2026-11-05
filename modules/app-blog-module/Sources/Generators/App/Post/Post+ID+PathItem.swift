import FeatherOpenAPI

extension Post.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Post.Get.Operation() }
    }
}
