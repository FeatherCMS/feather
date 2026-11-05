import FeatherOpenAPI

extension Job.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
