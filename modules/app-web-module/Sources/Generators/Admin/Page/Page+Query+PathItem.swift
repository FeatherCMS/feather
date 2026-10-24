public import FeatherOpenAPI

extension Page.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Page.Query.Operation() }
    }
}
