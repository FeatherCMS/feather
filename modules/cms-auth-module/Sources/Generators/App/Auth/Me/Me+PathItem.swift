import FeatherOpenAPI

extension Auth.Me {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
