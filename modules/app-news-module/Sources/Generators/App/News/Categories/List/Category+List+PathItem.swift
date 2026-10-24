import FeatherOpenAPI

extension Category.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
