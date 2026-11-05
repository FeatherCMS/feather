import FeatherOpenAPI

extension Campaign.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
