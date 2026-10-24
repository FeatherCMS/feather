import FeatherOpenAPI

extension Article.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
