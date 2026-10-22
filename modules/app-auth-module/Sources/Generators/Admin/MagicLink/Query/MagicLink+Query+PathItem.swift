import FeatherOpenAPI

extension MagicLink.Query {

    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { MagicLink.Query.Operation() }
    }
}
