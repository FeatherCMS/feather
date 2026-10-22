import FeatherOpenAPI

extension BlogPost.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
