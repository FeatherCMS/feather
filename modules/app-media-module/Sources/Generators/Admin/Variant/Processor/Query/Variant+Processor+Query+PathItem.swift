import FeatherOpenAPI

extension Variant.Processor.Query {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
