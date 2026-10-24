import FeatherOpenAPI

extension Rule.Get {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
