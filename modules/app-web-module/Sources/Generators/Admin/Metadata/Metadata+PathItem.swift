public import FeatherOpenAPI

extension Metadata {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var post: (any OperationRepresentable)? { Metadata.Post.Operation() }
        var delete: (any OperationRepresentable)? {
            Metadata.Delete.Operation()
        }
    }
}
