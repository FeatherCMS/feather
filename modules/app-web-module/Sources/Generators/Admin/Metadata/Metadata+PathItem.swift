public import FeatherOpenAPI

extension Metadata {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Metadata.Post.Operation() }
        var delete: (any OperationRepresentable)? {
            Metadata.Delete.Operation()
        }
    }
}
