import FeatherOpenAPI

extension MagicLink {

    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { MagicLink.List.Operation() }
        var post: (any OperationRepresentable)? { MagicLink.Post.Operation() }
        var delete: (any OperationRepresentable)? {
            MagicLink.Delete.Operation()
        }
    }
}
