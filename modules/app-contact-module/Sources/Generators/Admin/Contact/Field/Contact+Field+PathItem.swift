import FeatherOpenAPI

extension Contact.Field {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var post: (any OperationRepresentable)? { Post.Operation() }
        var delete: (any OperationRepresentable)? { Delete.Operation() }
    }
}

extension Contact.Field.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            Contact.Field.Get.Operation()
        }
        var put: (any OperationRepresentable)? {
            Contact.Field.Put.Operation()
        }
    }
}
