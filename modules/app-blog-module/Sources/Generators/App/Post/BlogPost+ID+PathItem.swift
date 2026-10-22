import FeatherOpenAPI

extension BlogPost.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { BlogPost.Get.Operation() }
    }
}
