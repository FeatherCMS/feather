import FeatherOpenAPI

extension Post.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Post.Get.Operation() }
        var put: (any OperationRepresentable)? { Post.Put.Operation() }
        var patch: (any OperationRepresentable)? { Post.Patch.Operation() }
    }
}
