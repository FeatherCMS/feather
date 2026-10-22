import FeatherOpenAPI

extension BlogAuthor.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
