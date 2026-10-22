import FeatherOpenAPI

extension Auth.MagicLink.Verify {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
