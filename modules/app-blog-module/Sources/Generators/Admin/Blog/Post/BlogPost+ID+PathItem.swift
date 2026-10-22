import FeatherOpenAPI

extension BlogPost.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { BlogPost.Get.Operation() }
        var put: (any OperationRepresentable)? { BlogPost.Put.Operation() }
        var patch: (any OperationRepresentable)? { BlogPost.Patch.Operation() }
    }
}
