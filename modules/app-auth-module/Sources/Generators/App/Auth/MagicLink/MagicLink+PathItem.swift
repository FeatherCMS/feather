import FeatherOpenAPI

extension Auth.MagicLink {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
