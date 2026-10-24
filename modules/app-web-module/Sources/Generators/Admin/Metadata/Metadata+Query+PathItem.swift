public import FeatherOpenAPI

extension Metadata.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Metadata.Query.Operation() }
    }
}
