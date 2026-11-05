import FeatherOpenAPI

extension Rule.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
