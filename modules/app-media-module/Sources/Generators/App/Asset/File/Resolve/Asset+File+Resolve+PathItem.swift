import FeatherOpenAPI

extension Asset.File.Resolve {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
