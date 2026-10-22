import FeatherOpenAPI

extension Auth.Logout {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
