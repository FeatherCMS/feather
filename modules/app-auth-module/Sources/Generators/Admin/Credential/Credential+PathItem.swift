import FeatherOpenAPI

extension Credential {

    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Credential.List.Operation() }
        var post: (any OperationRepresentable)? { Credential.Post.Operation() }
        var delete: (any OperationRepresentable)? {
            Credential.Delete.Operation()
        }
    }
}
