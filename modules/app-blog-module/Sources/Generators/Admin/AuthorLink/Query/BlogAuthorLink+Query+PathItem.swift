import FeatherOpenAPI

extension BlogAuthorLink.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
