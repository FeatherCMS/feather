import FeatherOpenAPI

extension Auth.Login {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
