import FeatherOpenAPI

extension ContactSubmission.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
