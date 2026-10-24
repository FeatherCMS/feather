import FeatherOpenAPI

extension Contact.Form {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var post: (any OperationRepresentable)? { Post.Operation() }
        var delete: (any OperationRepresentable)? { Delete.Operation() }
    }
}

extension Contact.Form.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Contact.Form.Get.Operation() }
        var put: (any OperationRepresentable)? { Contact.Form.Put.Operation() }
    }
}
