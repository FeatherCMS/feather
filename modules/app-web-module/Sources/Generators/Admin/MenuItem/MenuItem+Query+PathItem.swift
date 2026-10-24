public import FeatherOpenAPI

extension MenuItem.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { MenuItem.Query.Operation() }
    }
}
