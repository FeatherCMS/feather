import FeatherOpenAPI

extension BlogTag.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
