import FeatherOpenAPI

extension Credential.Query {

    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Credential.Query.Operation() }
    }
}
