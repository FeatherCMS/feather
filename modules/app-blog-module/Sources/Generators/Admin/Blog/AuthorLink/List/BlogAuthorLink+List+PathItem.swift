import FeatherOpenAPI

extension BlogAuthorLink.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
